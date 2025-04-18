import SwiftUI

/// A view that displays a board item as a rounded rectangle.
/// The view supports both edit and play modes, with different interactions for each.
struct BoardItemView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(BoardViewModel.self) private var viewModel

  @EnvironmentObject private var osc: OSCHelper

  @State private var showObject: ShowObject? = nil
  @State var showObjectRepository: ShowObjectRepository? = nil

  /// The board item to display
  let item: BoardItem

  /// Whether the board is in edit mode
  let isEditMode: Bool

  /// The current zoom level
  let zoomLevel: Double

  var body: some View {
    Button {
      if !isEditMode {
        if let showObject = showObject {
          sendOSC(for: showObject)
        }
      }
    } label: {
      ZStack {
        if let showObject = showObject {
          RoundedRectangle(cornerRadius: DOUBLE_CORNER_RADIUS)
            .fill(showObject.isOutlined ? Color.clear : OBJ_COLORS[showObject.getColor()])
            .overlay(
              RoundedRectangle(cornerRadius: DOUBLE_CORNER_RADIUS)
                .stroke(OBJ_COLORS[showObject.getColor()], lineWidth: BASE_LINE_WIDTH)
            )
            .overlay(
              VStack(alignment: .leading) {
                HStack {
                  Text(showObject.getShortType())
                  Spacer()
                  Text(showObject.getObjNumber())
                }
                Spacer()
                Text(showObject.getName())
                  .font(.headline)
              }
              .padding(8)
            )
        }

        if isEditMode {
          // Top left handle
          ResizeHandle()
            .position(x: 0, y: 0)
            .gesture(
              DragGesture()
                .onChanged { value in
                  handleResize(value, corner: .topLeft)
                }
                .onEnded { _ in
                  viewModel.registerResizeUndo(for: item)
                }
            )

          // Top right handle
          ResizeHandle()
            .rotationEffect(.degrees(90))
            .position(x: item.size.width * zoomLevel, y: 0)
            .gesture(
              DragGesture()
                .onChanged { value in
                  handleResize(value, corner: .topRight)
                }
                .onEnded { _ in
                  viewModel.registerResizeUndo(for: item)
                }
            )

          // Bottom left handle
          ResizeHandle()
            .rotationEffect(.degrees(-90))
            .position(x: 0, y: item.size.height * zoomLevel)
            .gesture(
              DragGesture()
                .onChanged { value in
                  handleResize(value, corner: .bottomLeft)
                }
                .onEnded { _ in
                  viewModel.registerResizeUndo(for: item)
                }
            )

          // Bottom right handle
          ResizeHandle()
            .rotationEffect(.degrees(-180))
            .position(x: item.size.width * zoomLevel, y: item.size.height * zoomLevel)
            .gesture(
              DragGesture()
                .onChanged { value in
                  handleResize(value, corner: .bottomRight)
                }
                .onEnded { _ in
                  viewModel.registerResizeUndo(for: item)
                }
            )
        }
      }
      .frame(width: item.size.width * zoomLevel, height: item.size.height * zoomLevel)
    }
    .buttonStyle(.plain)
    // Context menu is handled here because it's specific to this item
    // and doesn't need to coordinate with other items
    .contextMenu {
      if isEditMode {
        Button("Reassign") {
          viewModel.reassignItem(item)
        }
        Button("Remove", role: .destructive) {
          viewModel.removeItem(item)
        }
      }
    }
    // Drag gesture is handled here because:
    // Each item needs to be independently interactive
    // The view model has access to all items for overlap checking
    // Grid snapping is consistent through the view model
    // Undo support is managed by the view model
    .gesture(
      DragGesture()
        .onChanged { value in
          guard isEditMode else { return }

          // Calculate new position in grid units
          let gridSize = 44.0
          let newX =
            round((item.position.x + value.translation.width / zoomLevel) / gridSize) * gridSize
          let newY =
            round((item.position.y + value.translation.height / zoomLevel) / gridSize) * gridSize

          // Check for overlaps
          let newPosition = CGPoint(x: newX, y: newY)
          if !viewModel.wouldOverlap(item: item, at: newPosition) {
            viewModel.moveItem(item, to: newPosition)
          }
        }
        .onEnded { _ in
          // Register with undo manager
          viewModel.registerMoveUndo(for: item)
        }
    )
    .task {
      do {
        let repo =
          showObjectRepository
          ?? ShowObjectSwiftDataRepository(modelContainer: modelContext.container)
        showObject = try await repo.getObject(by: item.showObjectID)
      } catch {
        HogLogger.log(category: .board).error("Error fetching show object: \(error)")
      }
    }
  }

  private func sendOSC(for object: ShowObject) {
    let objNum = object.getObjNumber()
    switch object.objType {
      case .group, .intensity, .position, .color, .beam, .effect:
        osc.selectProgrammingObject(objNumber: objNum, objType: object.objType)
      case .list:
        osc.goList(objNumber: objNum)
      case .scene:
        osc.goScene(objNumber: objNum)
      default:
        HogLogger.log(category: .board).error("Invalid object type for board item")
    }
  }

  private func handleResize(_ value: DragGesture.Value, corner: ResizeCorner) {
    guard isEditMode else { return }

    let gridSize = 44.0
    let minSize = gridSize  // Minimum 1x1 grid unit

    // Calculate new size based on drag and corner
    var newWidth = item.size.width
    var newHeight = item.size.height

    switch corner {
      case .topLeft:
        newWidth = max(
          minSize,
          round((item.size.width - value.translation.width / zoomLevel) / gridSize) * gridSize
        )
        newHeight = max(
          minSize,
          round((item.size.height - value.translation.height / zoomLevel) / gridSize) * gridSize
        )
      case .topRight:
        newWidth = max(
          minSize,
          round((item.size.width + value.translation.width / zoomLevel) / gridSize) * gridSize
        )
        newHeight = max(
          minSize,
          round((item.size.height - value.translation.height / zoomLevel) / gridSize) * gridSize
        )
      case .bottomLeft:
        newWidth = max(
          minSize,
          round((item.size.width - value.translation.width / zoomLevel) / gridSize) * gridSize
        )
        newHeight = max(
          minSize,
          round((item.size.height + value.translation.height / zoomLevel) / gridSize) * gridSize
        )
      case .bottomRight:
        newWidth = max(
          minSize,
          round((item.size.width + value.translation.width / zoomLevel) / gridSize) * gridSize
        )
        newHeight = max(
          minSize,
          round((item.size.height + value.translation.height / zoomLevel) / gridSize) * gridSize
        )
    }

    // Check for overlaps with new size
    if !viewModel.wouldOverlap(item: item, with: CGSize(width: newWidth, height: newHeight)) {
      viewModel.resizeItem(item, to: CGSize(width: newWidth, height: newHeight))
    }
  }
}

// Corner enum for resize handles
private enum ResizeCorner {
  case topLeft
  case topRight
  case bottomLeft
  case bottomRight
}

#Preview("Edit Mode") {
  BoardItemView(
    showObjectRepository: ShowObjectMockRepository.preview,
    item: BoardItemMockRepository.previewWithItems.items[1],
    isEditMode: true,
    zoomLevel: 1.0
  )
  .environment(
    BoardViewModel(
      board: BoardMockRepository.previewWithBoards.boards[0],
      boardState: BoardState(isEditMode: true),
      repository: BoardMockRepository.previewWithBoards,
      itemRepository: BoardItemMockRepository.previewWithItems
    )
  )
  .environmentObject(OSCHelper(ip: "127.0.0.1", inputPort: 7001, outputPort: 7002))
  .padding()
}

#Preview("Play Mode") {
  BoardItemView(
    showObjectRepository: ShowObjectMockRepository.preview,
    item: BoardItemMockRepository.previewWithItems.items[0],
    isEditMode: false,
    zoomLevel: 1.0
  )
  .environment(
    BoardViewModel(
      board: BoardMockRepository.previewWithBoards.boards[0],
      boardState: BoardState(isEditMode: false),
      repository: BoardMockRepository.previewWithBoards,
      itemRepository: BoardItemMockRepository.previewWithItems
    )
  )
  .environmentObject(OSCHelper(ip: "127.0.0.1", inputPort: 7001, outputPort: 7002))
  .padding()
}
