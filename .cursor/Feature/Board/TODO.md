# Board Feature Implementation Steps

## Step 1: Data Models & Repositories

- [ ] Create `Board.swift` in Data/Models
  - [ ] Properties: 
    - id: UUID
    - name: String
    - showID: UUID
    - lastPanOffset: CGPoint (from lastPanOffsetX/Y)
    - lastZoomScale: CGFloat
    - dateLastModified: Date
  - [ ] Add init(from entity: BoardEntity)
  - [ ] Add preview data
  - [ ] Add unit tests for model properties and initialization

- [ ] Create `BoardEntity.swift` in Data/ManagedModels
  - [ ] Properties:
    - id: UUID?
    - name: String?
    - showID: UUID?
    - lastPanOffsetX: Double?
    - lastPanOffsetY: Double?
    - lastZoomScale: Double?
    - dateLastModified: Date? (auto-updates on any property change and when board is opened)
  - [ ] Add show: ShowEntity? property (relationship managed by ShowEntity)
  - [ ] Add @Relationship(deleteRule: .cascade) to BoardItemEntity
  - [ ] Add @Relationship(inverse: \BoardItemEntity.board) var items: [BoardItemEntity]?
  - [ ] Make all properties optional for CloudKit support
  - [ ] Make all relationships optional for CloudKit support
  - [ ] Add @Model annotation for SwiftData
  - [ ] Ensure model supports CloudKit sync
  - [ ] Add unit tests for entity properties and relationships

- [ ] Update `ShowEntity.swift` in Data/ManagedModels
  - [ ] Add @Relationship(deleteRule: .cascade, inverse: \BoardEntity.show) var boards: [BoardEntity]?
  - [ ] Make relationship optional for CloudKit support
  - [ ] Add unit tests for relationship

- [ ] Create `BoardItem.swift` in Data/Models
  - [ ] Properties:
    - id: UUID
    - boardID: UUID
    - itemType: ShowObjectType
    - referenceID: UUID (references ShowObjectEntity.id)
    - position: CGPoint (from positionX/Y, relative to board center)
    - size: CGSize (width/height in grid units, minimum 1x1)
  - [ ] Add init(from entity: BoardItemEntity)
  - [ ] Add preview data
  - [ ] Add unit tests for model properties and initialization

- [ ] Create `BoardItemEntity.swift` in Data/ManagedModels
  - [ ] Properties:
    - id: UUID?
    - boardID: UUID?
    - itemType: String that is equal to ShowObjectType.RawValue
    - referenceID: UUID?
    - positionX: Double?
    - positionY: Double?
    - width: Double?
    - height: Double?
  - [ ] Add @Relationship to BoardEntity
  - [ ] Add @Relationship(inverse: \ShowObjectEntity.boardItems) var showObject: ShowObjectEntity?
  - [ ] Make all properties optional for CloudKit support
  - [ ] Make all relationships optional for CloudKit support
  - [ ] Add @Model annotation for SwiftData
  - [ ] Ensure model supports CloudKit sync
  - [ ] Add unit tests for entity properties and relationships

- [ ] Create `BoardRepository.swift` protocol in Data/Repository/Board
  - [ ] async Create new board with name -> throws, returns Board
  - [ ] async Get boards for show sorted by dateLastModified in descending order (newest first) -> throws, returns [Board]
  - [ ] async Delete board by id -> throws
  - [ ] async Update board name by id -> throws, returns updated Board
  - [ ] async Update board pan offset by id -> throws, returns updated Board
  - [ ] async Update board zoom scale by id -> throws, returns updated Board
  - [ ] Add unit tests for protocol requirements
  - [ ] Add unit tests for sorting order
  - [ ] Add unit tests for dateLastModified updates

- [ ] Create `BoardSwiftDataRepository.swift`
  - [ ] Implement protocol
  - [ ] Add proper error handling
  - [ ] Add unit tests for all CRUD operations
  - [ ] Add unit tests for error cases
  - [ ] Add integration tests with SwiftData
  - [ ] Add unit tests for sorting order
  - [ ] Add unit tests for dateLastModified updates

- [ ] Create `BoardMockRepository.swift`
  - [ ] Implement protocol
  - [ ] Add preview data
  - [ ] Support all operations

- [ ] Create `BoardItemRepository.swift` protocol in Data/Repository/BoardItem
  - [ ] async Place new item on board (minimum size 2×2 grid units = 88×88 points) -> throws, returns BoardItem
  - [ ] async Get items for board sorted by positionY ascending, then positionX ascending (top to bottom, left to right) -> throws, returns [BoardItem]
  - [ ] async Update item position by id (must snap to 44×44 point grid) -> throws, returns updated BoardItem
  - [ ] async Update item size by id (minimum 2×2 grid units) -> throws, returns updated BoardItem
  - [ ] async Delete item by id -> throws
  - [ ] async Update item reference by id -> throws, returns updated BoardItem
  - [ ] Add unit tests for protocol requirements
  - [ ] Add unit tests for sorting order

- [ ] Create `BoardItemSwiftDataRepository.swift`
  - [ ] Implement protocol
  - [ ] Add proper error handling
  - [ ] Add unit tests for all CRUD operations
  - [ ] Add unit tests for error cases
  - [ ] Add integration tests with SwiftData
  - [ ] Add unit tests for sorting order

- [ ] Create `BoardItemMockRepository.swift`
  - [ ] Implement protocol
  - [ ] Add preview data
  - [ ] Support all operations

## Step 2: Basic Board List UI
- [ ] Create `BoardListViewModel.swift`
  - [ ] Handle board CRUD operations
    - [ ] Create new board with default name "New Board"
    - [ ] Auto-save boards when modified
    - [ ] Permanent deletion of boards
    - [ ] Load boards for current show
  - [ ] Handle board switching
    - [ ] Track currently selected board
    - [ ] Maintain board state during app suspension
  - [ ] Sort boards by last modified date (descending)
  - [ ] Handle error states
    - [ ] Creation failures
    - [ ] Loading failures
    - [ ] Deletion failures
    - [ ] Update failures
  - [ ] Add preview support
  - [ ] Add unit tests for all operations
  - [ ] Add unit tests for sorting
  - [ ] Add unit tests for state management

- [ ] Create `BoardListView.swift`
  - [ ] Implement grid layout for board thumbnails
    - [ ] Show scaled preview of entire board content
    - [ ] Display board title
    - [ ] Show last modified date using standard Date formatting
  - [ ] Add new board button using SF Symbol "plus.circle"
  - [ ] Handle board selection
    - [ ] Present selected board as full screen cover
    - [ ] Support dismissal back to grid
  - [ ] Add context menu actions for delete and rename
  - [ ] Add previews for all states

## Step 3: Basic Board Canvas
- [ ] Create `BoardViewModel.swift`
  - [ ] Handle edit/play mode state
    - [ ] Add enum `BoardMode` with cases `.edit` and `.play`
    - [ ] New boards default to edit mode
    - [ ] Existing boards open in play mode
  - [ ] Handle grid calculations (44×44 points per grid unit)
    - [ ] Implement coordinate system with (0,0) at board center
    - [ ] Add methods to convert between screen and grid coordinates
    - [ ] Add methods to snap positions to grid corners
  - [ ] Handle pan/zoom state
    - [ ] Support infinite panning in all directions
    - [ ] No zoom limits
    - [ ] Store and restore last pan offset and zoom scale per board
  - [ ] Handle undo/redo (within current edit session only)
    - [ ] Track object additions
    - [ ] Track object movements
    - [ ] Track object resizing
    - [ ] Track object reassignments
    - [ ] Track object removals
    - [ ] Clear history when leaving edit mode
  - [ ] Handle overlap detection between items
    - [ ] Detect overlaps during movement/resizing
    - [ ] Provide feedback for invalid positions
  - [ ] Add preview support
  - [ ] Add unit tests for all functionality

- [ ] Create `BoardView.swift`
  - [ ] Implement infinite canvas
    - [ ] Center origin at (0,0)
    - [ ] Support unlimited scrolling in all directions
  - [ ] Implement grid system
    - [ ] Show light grey dots at grid corners (44×44 pt spacing)
    - [ ] Grid always visible in edit mode
    - [ ] Grid always hidden in play mode
  - [ ] Handle pinch to zoom gesture
    - [ ] No zoom limits
    - [ ] Maintain zoom state per board
  - [ ] Handle drag to pan gesture
    - [ ] Support infinite panning
    - [ ] Maintain pan offset state per board
  - [ ] Add edit/play mode toggle button in toolbar
    - [ ] Edit mode: SF Symbol "pencil"
    - [ ] Play mode: SF Symbol "play.fill"
    - [ ] Standard iOS button feedback in play mode
  - [ ] Add previews for all states

- [ ] Update `BoardViewModel.swift`
  - [ ] Add unit tests for:
    - [ ] Grid coordinate conversion:
      - [ ] Screen to grid coordinates
      - [ ] Grid to screen coordinates
      - [ ] Edge cases (negative coordinates, large numbers)
      - [ ] Rounding/precision tests
    - [ ] Pan/zoom state:
      - [ ] Pan offset persistence
      - [ ] Zoom scale persistence
      - [ ] Combined pan and zoom transformations
    - [ ] Edit/Play mode:
      - [ ] Mode switching
      - [ ] Default modes (new vs existing boards)
      - [ ] Persistence of mode state

## Step 4: Board Item UI
- [ ] Create `ResizeHandleView.swift` in Views/Board
  ```swift
  import SwiftUI

  /// A view that displays a resize handle for board items.
  /// Creates the curved L-bracket corner piece seen in iOS Control Center resize handles.
  struct ResizeHandle: View {
    var body: some View {
      Path { path in
        // Start from the end of the horizontal part
        path.move(to: CGPoint(x: 0, y: 24))

        // Create the curved corner matching DOUBLE_CORNER_RADIUS
        path.addQuadCurve(
          to: CGPoint(x: 24, y: 0),
          control: CGPoint(x: 0, y: 0)
        )

        // Add thickness
        path.addLine(to: CGPoint(x: 24, y: 8))
        path.addQuadCurve(
          to: CGPoint(x: 8, y: 24),
          control: CGPoint(x: 8, y: 8)
        )
        path.closeSubpath()
      }
      .fill(.white)
      .frame(width: 24, height: 24)
    }
  }

  #Preview {
    ZStack(alignment: .topLeading) {
      RoundedRectangle(cornerRadius: DOUBLE_CORNER_RADIUS)
        .fill(Color.blue)
        .frame(width: 200, height: 200)

      ResizeHandle()
    }
    .frame(width: 200, height: 200)
    .padding(20)
  }
  ```

- [ ] Create `BoardItemView.swift`
  - [ ] Display show objects using same style as `ShowObjectView`
    - [ ] Match VStack layout with HStack header
    - [ ] Use same text styles (short type and number in header, name in headline font)
    - [ ] Support both filled and outlined states using `isOutlined`
    - [ ] Use same colors from `OBJ_COLORS`
    - [ ] Use `BASE_CORNER_RADIUS` and `DOUBLE_CORNER_RADIUS` constants
    - [ ] Use `BASE_LINE_WIDTH` for outline stroke
  - [ ] Implement base layout:
    - [ ] Support minimum size of 2×2 grid units (88×88 points)
    - [ ] Support non-square rectangular sizes
    - [ ] Maintain same padding as ShowObjectView
    - [ ] Position resize handles at corners with 24×24pt size
  - [ ] Handle mode-specific appearance:
    - [ ] Edit Mode: show resize handles
    - [ ] Play Mode: hide resize handles
  - [ ] Add accessibility:
    - [ ] Add accessibility labels to resize handles ("Resize from top-left corner", etc)
    - [ ] Ensure minimum 44×44pt touch targets for resize handles
  - [ ] Add resize handle states:
    - [ ] Default state (white fill)
    - [ ] Pressed state (darker fill)
  - [ ] Add previews for:
    - [ ] Common use cases (2×2 square in both modes, typical object)
    - [ ] Edge cases (large rectangular size, outlined vs filled)
    - [ ] Different object types in a grid layout

## Step 5: Object Selection & Placement
- [ ] Update `BoardViewModel.swift`
  - [ ] Track and validate tap location:
    - [ ] Convert tap location to grid coordinates (each grid unit is 44×44 points)
    - [ ] Align to grid so new 2×2 item's center is at the closest grid dot to the tap
    - [ ] Check if 2×2 item at this position would overlap any existing items
    - [ ] Only allow sheet presentation if no overlap would occur
  - [ ] Handle object placement:
    - [ ] Create new BoardItemEntity only after successful object selection
    - [ ] Set position from validated tap location
    - [ ] Set default 2×2 size (88×88 points)
    - [ ] Link to selected ShowObjectEntity
  - [ ] Add gesture coordination:
    - [ ] Add tap gesture recognition
    - [ ] Only recognize tap when no other gestures are in progress
  - [ ] Add unit tests for:
    - [ ] Grid alignment calculation
    - [ ] Overlap detection with existing items
    - [ ] Object creation with default size

- [ ] Create `ObjectSelectionMenu.swift`
  - [ ] Use standard iOS sheet presentation
  - [ ] Use `.searchable` modifier with token support for:
    - [ ] Text search across object properties
    - [ ] Object type filtering via tokens
    - [ ] Combined search and filter (search within selected type)
  - [ ] Display list of show objects with each item showing:
    - [ ] Object type (group, intensity, position, color, beam, effect, list, scene, etc)
    - [ ] Object number
    - [ ] Object name
    - [ ] Object color (using `OBJ_COLORS`)
  - [ ] Group and sort objects:
    - [ ] Group by object type
    - [ ] Sort by object number within groups
  - [ ] Handle object selection and sheet dismissal:
    - [ ] On selection: return selected object and dismiss
    - [ ] On cancel/dismiss: return nil and dismiss
  - [ ] Add previews for:
    - [ ] List with multiple object types
    - [ ] Search results
    - [ ] Empty search state

- [ ] Update `BoardView.swift`
  - [ ] Add tap gesture only in edit mode
  - [ ] Present sheet only in Edit Mode
  - [ ] Handle sheet dismissal (return to board with no changes)
  - [ ] Add previews for placement workflow

## Step 6: Item Movement & Resizing
- [ ] Update `BoardViewModel.swift`
  - [ ] Handle drag gesture for item movement:
    - [ ] During drag:
      - [ ] Calculate nearest grid dot to current drag position
      - [ ] Snap item center to that grid dot
      - [ ] Check for overlaps with other items
    - [ ] On drag end:
      - [ ] If position is invalid (has overlaps):
        - [ ] Return to original position
      - [ ] If position is valid:
        - [ ] Update item position in SwiftData
  - [ ] Handle resize gesture:
    - [ ] During resize:
      - [ ] Calculate new size in grid units from gesture
      - [ ] Enforce minimum 2×2 grid unit size
      - [ ] Snap to grid dots
      - [ ] Check for overlaps with other items
    - [ ] On resize end:
      - [ ] If size/position is invalid (has overlaps):
        - [ ] Return to original size
      - [ ] If size is valid:
        - [ ] Update item size in SwiftData
  - [ ] Add unit tests for:
    - [ ] Grid snapping calculations
    - [ ] Overlap detection
    - [ ] Minimum size enforcement
    - [ ] Position/size reversion

- [ ] Update `BoardItemView.swift`
  - [ ] Add drag gesture (Edit Mode only):
    - [ ] Implement gesture with proper priority
    - [ ] Pass drag updates to ViewModel
  - [ ] Add corner resize gestures (Edit Mode only):
    - [ ] Implement gestures with proper priority
    - [ ] Pass resize updates to ViewModel
  - [ ] Add visual feedback:
    - [ ] Invalid state when overlapping during drag/resize

## Step 7: Navigation Integration
- [ ] Update `ShowNavigation.swift`
  - [ ] Add Boards tab using SF Symbol "square.grid.3x3"
  - [ ] Handle navigation state for boards
  - [ ] Add unit tests for:
    - [ ] Tab selection state
    - [ ] Navigation path management

## Step 8: Performance Testing
- [ ] Performance testing
  - [ ] Test with large number of items
  - [ ] Test with complex item layouts
  - [ ] Test with rapid interactions
  - [ ] Test memory usage
  - [ ] Test battery impact
