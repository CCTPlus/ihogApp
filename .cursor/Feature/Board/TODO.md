# Board Feature Implementation Steps

## Step 1: Data Models & Repositories

- [x] Create `Board.swift` in Data/Models
  - [x] Properties: 
    - id: UUID
    - name: String
    - showID: UUID
    - lastPanOffset: CGPoint (from lastPanOffsetX/Y)
    - lastZoomScale: CGFloat
    - dateLastModified: Date
  - [x] Add init(from entity: BoardEntity)
  - [x] Add preview data
  - [x] Add unit tests for model properties and initialization

- [x] Create `BoardEntity.swift` in Data/ManagedModels
  - [x] Properties:
    - id: UUID?
    - name: String?
    - showID: UUID?
    - lastPanOffsetX: Double?
    - lastPanOffsetY: Double?
    - lastZoomScale: Double?
    - dateLastModified: Date? (auto-updates on any property change and when board is opened)
  - [x] Add show: ShowEntity? property (relationship managed by ShowEntity)
  - [x] Add @Relationship(deleteRule: .cascade) to BoardItemEntity
  - [x] Add @Relationship(inverse: \BoardItemEntity.board) var items: [BoardItemEntity]?
  - [x] Make all properties optional for CloudKit support
  - [x] Make all relationships optional for CloudKit support
  - [x] Add @Model annotation for SwiftData
  - [x] Ensure model supports CloudKit sync
  - [x] Add unit tests for entity properties and relationships

- [x] Update `ShowEntity.swift` in Data/ManagedModels
  - [x] Add @Relationship(deleteRule: .cascade, inverse: \BoardEntity.show) var boards: [BoardEntity]?
  - [x] Make relationship optional for CloudKit support
  - [x] Add unit tests for relationship

- [x] Create `BoardItem.swift` in Data/Models
  - [x] Properties:
    - id: UUID
    - boardID: UUID
    - itemType: ShowObjectType
    - referenceID: UUID (references ShowObjectEntity.id)
    - position: CGPoint (from positionX/Y, relative to board center)
    - size: CGSize (width/height in grid units, minimum 1x1)
  - [x] Add init(from entity: BoardItemEntity)
  - [x] Add preview data
  - [x] Add unit tests for model properties and initialization

- [x] Create `BoardItemEntity.swift` in Data/ManagedModels
  - [x] Properties:
    - id: UUID?
    - boardID: UUID?
    - itemType: String that is equal to ShowObjectType.RawValue
    - referenceID: UUID?
    - positionX: Double?
    - positionY: Double?
    - width: Double?
    - height: Double?
  - [x] Add @Relationship to BoardEntity
  - [x] Add @Relationship(inverse: \ShowObjectEntity.boardItems) var showObject: ShowObjectEntity?
  - [x] Make all properties optional for CloudKit support
  - [x] Make all relationships optional for CloudKit support
  - [x] Add @Model annotation for SwiftData
  - [x] Ensure model supports CloudKit sync
  - [x] Add unit tests for entity properties and relationships

- [x] Create `BoardRepository.swift` protocol in Data/Repository/Board
  - [x] async Create new board with name -> throws, returns Board
  - [x] async Get boards for show sorted by dateLastModified in descending order (newest first) -> throws, returns [Board]
  - [x] async Delete board by id -> throws
  - [x] async Update board name by id -> throws, returns updated Board
  - [x] async Update board pan offset by id -> throws, returns updated Board
  - [x] async Update board zoom scale by id -> throws, returns updated Board
  - [x] Add unit tests for protocol requirements

- [x] Create `BoardSwiftDataRepository.swift`
  - [x] Implement protocol
  - [x] Add proper error handling
  - [x] Add unit tests for all CRUD operations
  - [x] Add unit tests for error cases
  - [x] Add integration tests with SwiftData
  - [x] Add unit tests for sorting order
  - [x] Add unit tests for dateLastModified updates

- [x] Create `BoardMockRepository.swift`
  - [x] Implement protocol
  - [x] Add preview data
  - [x] Support all operations

- [x] Create `BoardItemRepository.swift` protocol in Data/Repository/BoardItem
  - [x] async Place new item on board (minimum size 2×2 grid units = 88×88 points) -> throws, returns BoardItem
  - [x] async Get items for board sorted by positionY ascending, then positionX ascending (top to bottom, left to right) -> throws, returns [BoardItem]
  - [x] async Update item position by id (must snap to 44×44 point grid) -> throws, returns updated BoardItem
  - [x] async Update item size by id (minimum 2×2 grid units) -> throws, returns updated BoardItem
  - [x] async Delete item by id -> throws
  - [x] async Update item reference by id -> throws, returns updated BoardItem

- [x] Create `BoardItemSwiftDataRepository.swift`
  - [x] Implement protocol
  - [x] Add proper error handling
  - [x] Add unit tests for all CRUD operations
  - [x] Add unit tests for error cases
  - [x] Add integration tests with SwiftData

- [x] Create `BoardItemMockRepository.swift`
  - [x] Implement protocol
  - [x] Add preview data
  - [x] Support all operations

## Step 2: Basic Board List UI
- [x] Create `BoardListViewModel.swift`
  - [x] Handle board CRUD operations
    - [x] Create new board with default name "New Board"
    - [x] Auto-save boards when modified
    - [x] Permanent deletion of boards
    - [x] Load boards for current show
  - [x] Handle board switching
    - [x] Track currently selected board
    - [x] Maintain board state during app suspension
  - [x] Sort boards by last modified date (descending)
  - [x] Handle error states
    - [x] Creation failures
    - [x] Loading failures
    - [x] Deletion failures
    - [x] Update failures
  - [x] Add preview support
  - [x] Add unit tests for all operations
  - [x] Add unit tests for sorting
  - [x] Add unit tests for state management

- [ ] Create `BoardListView.swift`
  - [x] Implement grid layout for board thumbnails
    - [x] Display board title
    - [x] Show last modified date using standard Date formatting
  - [x] Add new board button using SF Symbol "plus.circle"
  - [x] Handle board selection
    - [x] Present selected board as full screen cover
    - [x] Support dismissal back to grid
  - [x] Add context menu actions for delete and rename
  - [x] Add previews for all states

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

- [x] Create `BoardView.swift`
  - [x] Implement infinite canvas
    - [x] Center origin at (0,0)
    - [x] Support unlimited scrolling in all directions
  - [x] Implement grid system
    - [x] Show light grey dots at grid corners (44×44 pt spacing)
    - [x] Grid always visible in edit mode
    - [x] Grid always hidden in play mode
  - [x] Handle pinch to zoom gesture
    - [x] No zoom limits
    - [x] Maintain zoom state per board
  - [x] Handle drag to pan gesture
    - [x] Support infinite panning
    - [x] Maintain pan offset state per board
  - [x] Add edit/play mode toggle button in toolbar
    - [x] Edit mode: SF Symbol "pencil
    - [x] Play mode: SF Symbol "play.fill"
    - [x] Standard iOS button feedback in play mode
  - [x] Add previews for all states
  - [x] Update BoardListView to use BoardView for previews and full screen presentation
  - [x] Implement `BoardThumbnailView.swift`
    - [x] Create reusable component for board thumbnails
    - [x] Accept board model and scale factor as parameters
    - [x] Display board items at correct positions and sizes
    - [x] Maintain aspect ratio of board content
    - [x] Add border and rounded corners to match design
    - [x] Ensure performance with multiple thumbnails
    - [x] Add unit tests for thumbnail rendering
    - [x] Add previews for different board layouts
  - [x] Update BoardListView to use BoardThumbnailView

## Step 4: Board Item UI
- [x] Create `ResizeHandleView.swift` in Views/Board
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

- [x] Create `BoardItemView.swift`
  - [x] Display show objects using same style as `ShowObjectView`
    - [x] Match VStack layout with HStack header
    - [x] Use same text styles (short type and number in header, name in headline font)
    - [x] Support both filled and outlined states using `isOutlined`
    - [x] Use same colors from `OBJ_COLORS`
    - [x] Use `BASE_CORNER_RADIUS` and `DOUBLE_CORNER_RADIUS` constants
    - [x] Use `BASE_LINE_WIDTH` for outline stroke
  - [x] Implement base layout:
    - [x] Support minimum size of 2×2 grid units (88×88 points)
    - [x] Support non-square rectangular sizes
    - [x] Maintain same padding as ShowObjectView
    - [x] Position resize handles at corners with 24×24pt size
  - [x] Handle mode-specific appearance:
    - [x] Edit Mode: show resize handles
    - [x] Play Mode: hide resize handles
  - [x] Add accessibility:
    - [x] Add accessibility labels to resize handles
    - [x] Ensure minimum 44×44pt touch targets for resize handles
  - [x] Add resize handle states:
    - [x] Default state (white fill)
    - [x] Pressed state (darker fill)
  - [x] Add previews for:
    - [x] Common use cases (2×2 square in both modes, typical object)
    - [x] Edge cases (large rectangular size, outlined vs filled)
    - [x] Different object types in a grid layout

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
  - [ ] Add Boards tab using SF Symbol "puzzlepiece"
  - [ ] Handle navigation state for boards
  - [ ] Add unit tests for:
    - [ ] Tab selection state
    - [ ] Navigation path management
- [ ] Tests to do
  - [ ] Check that zoom maginificationgesture works

## Step 8: Performance Testing
- [ ] Performance testing
  - [ ] Test with large number of items
  - [ ] Test with complex item layouts
  - [ ] Test with rapid interactions
  - [ ] Test memory usage
  - [ ] Test battery impact