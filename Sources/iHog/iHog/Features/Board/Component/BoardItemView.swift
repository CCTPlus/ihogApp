import SwiftUI

/// A view that displays a board item with resize handles and show object content.
/// Matches the style of ShowObjectView while adding resize functionality.
struct BoardItemView: View {
  @State var viewModel: BoardItemViewModel
  let isEditMode: Bool

  var body: some View {
    if let showObject = viewModel.showObject {
      ZStack(alignment: .topLeading) {
        // Main content matching ShowObjectView style
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
        .frame(width: viewModel.size.width, height: viewModel.size.height)
        .padding()
        .background(
          showObject.isOutlined ? Color.clear : OBJ_COLORS[showObject.getColor()]
        )
        .cornerRadius(BASE_CORNER_RADIUS)
        .overlay(
          RoundedRectangle(cornerRadius: DOUBLE_CORNER_RADIUS)
            .stroke(OBJ_COLORS[showObject.getColor()], lineWidth: BASE_LINE_WIDTH)
        )
      }
      .frame(minWidth: 88, minHeight: 88)  // 2x2 grid units minimum
      .padding(8)
      .overlay {
        if isEditMode {
          VStack {
            HStack {
              ResizeHandle()
                .rotationEffect(.degrees(0))
                .accessibilityLabel("Resize from top-left corner")
              Spacer()
              ResizeHandle()
                .rotationEffect(.degrees(90))
                .accessibilityLabel("Resize from top-right corner")
            }
            Spacer()
            HStack {
              ResizeHandle()
                .rotationEffect(.degrees(270))
                .accessibilityLabel("Resize from bottom-left corner")
              Spacer()
              ResizeHandle()
                .rotationEffect(.degrees(180))
                .accessibilityLabel("Resize from bottom-right corner")
            }
          }
        }
      }
    } else {
      Color.clear
        .task {
          await viewModel.fetchShowObject()
        }
    }
  }
}

#Preview("2x2 Square - Edit Mode") {
  @Previewable @State var viewModel = BoardItemViewModel(
    boardItem: BoardItem.previewGroup,
    showObjectRepository: ShowObjectMockRepository.preview
  )
  BoardItemView(
    viewModel: viewModel,
    isEditMode: true
  )
  .padding()
}

#Preview("2x2 Square - Play Mode") {
  @Previewable @State var viewModel = BoardItemViewModel(
    boardItem: BoardItem.previewGroup,
    showObjectRepository: ShowObjectMockRepository.preview
  )
  BoardItemView(
    viewModel: viewModel,
    isEditMode: false
  )
  .padding()
  .task {
    await viewModel.fetchShowObject()
  }
}

#Preview("Large Rectangle - Edit Mode") {
  @Previewable @State var viewModel = BoardItemViewModel(
    boardItem: BoardItem(
      boardID: UUID(),
      itemType: .group,
      referenceID: testShowObjects[0].id,
      position: .zero,
      size: CGSize(width: 176, height: 88)
    ),
    showObjectRepository: ShowObjectMockRepository.preview
  )
  BoardItemView(
    viewModel: viewModel,
    isEditMode: true
  )
}

#Preview("Grid Layout") {
  @Previewable @State var groupViewModel = BoardItemViewModel(
    boardItem: BoardItem.previewGroup,
    showObjectRepository: ShowObjectMockRepository.preview
  )
  @Previewable @State var intensityViewModel = BoardItemViewModel(
    boardItem: BoardItem.previewIntensity,
    showObjectRepository: ShowObjectMockRepository.preview
  )
  @Previewable @State var positionViewModel = BoardItemViewModel(
    boardItem: BoardItem.previewPosition,
    showObjectRepository: ShowObjectMockRepository.preview
  )
  @Previewable @State var colorViewModel = BoardItemViewModel(
    boardItem: BoardItem.previewColor,
    showObjectRepository: ShowObjectMockRepository.preview
  )

  VStack(spacing: 20) {
    HStack(spacing: 20) {
      BoardItemView(
        viewModel: groupViewModel,
        isEditMode: false
      )
      BoardItemView(
        viewModel: intensityViewModel,
        isEditMode: false
      )
    }
    HStack(spacing: 20) {
      BoardItemView(
        viewModel: positionViewModel,
        isEditMode: false
      )
      BoardItemView(
        viewModel: colorViewModel,
        isEditMode: false
      )
    }
  }
}
