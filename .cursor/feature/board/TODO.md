# Board Feature Implementation

The purpose of this document is to give an AI agent a step by step guide on how to build a feature. It should follow these steps and implementation in the order given. There should be no adding features. There should be no assumptions. If something is unclear, the AI agent needs to stop and ask for more instructions. Each section should be implemented one at a time and one file at a time.

General guidance on SwiftUI view:

- Each view or component must have it's own file.
- Each view or component must have Previews. If there are multiple states, then there must be a preview for each state.
- Previews must use the mock repository
- Views should be folling an MVVM pattern and using the observation framework

General guidance on coding:
- Comments need to be added for each significant piece of code explaining what it does
- All models must be fetched using the repository architecture. Each repository has a protcol so that must be adjusted first.
- Coding style must match the style of other files in the app.

Guidence about the project:
- The app uses a repository architecture to manipulate and fetch items from SwiftData.
- Entities or managed objects are NOT to be used in views. Only non managed models can be used in views
- All source files live in Sources/iHog/iHog

## 1. Feature Structure Setup
1. [x] Create directory structure:
   - Features/Board/
     - Models/
     - Views/
     - Components/

2. [x] Setup Data Layer Dependencies
   - Data/Repository/BoardItem/
     - [x] BoardItemRepository.swift (protocol)
       - Define async protocol
       - Will contain operations for managing board items (specific operations added as features are implemented)
     - [x] BoardItemSwiftDataRepository.swift
       - Implement SwiftData-backed repository
       - Use ModelActor for all data operations
       - Handle entity <-> model conversion
     - [x] BoardItemMockRepository.swift
       - Implement in-memory repository for previews
       - Add sample data matching real data patterns
       - Mirror SwiftData implementation behavior

3. [x] Create and implement foundation:
   - Models/
     - [x] BoardState.swift (class)
       - Current zoom level (no zoom limits)
       - Current offset (supports infinite panning)
       - Edit/Play mode
       - Grid visibility:
         - Always visible in Edit Mode
         - Always hidden in Play Mode
       - Properties:
         - zoomLevel: Double = 1.0
         - contentOffset: CGPoint = .zero  // (0,0) center
         - isEditMode: Bool = true  // Start in edit mode
         - isGridVisible: Bool  // True in Edit Mode, false in Play Mode
         - lastSavedOffset: CGPoint?  // Loaded from BoardEntity via SwiftData
         - lastSavedZoom: Double?  // Loaded from BoardEntity via SwiftData
     - [x] BoardViewModel.swift (@Observable)
       - Owns/manages BoardState instance
       - Handles Board/BoardEntity persistence through SwiftData
       - Reads lastPanOffset/lastZoomScale from Board model
       - NSUndoManager handling:
         - Cleared immediately on Edit Mode exit
         - Only tracks within current Edit Mode session
         - Records: object add/move/resize/reassign/remove
         - Does not track zoom/pan changes
       - Properties:
         - boardState: BoardState
         - undoManager: NSUndoManager?
         - repository: BoardRepository
       - Methods needed:
         - init(boardID: UUID)
         - updateZoom(to: Double)
         - updateOffset(to: CGPoint)
         - toggleEditMode()
         - save()  // Saves to SwiftData via repository
         - restore()  // Loads from SwiftData via repository

4. [x] Create core board structure:
   - Views/
     - [x] BoardView.swift (container)
       - [x] Infinite scrollable area:
         - Both axes enabled
         - No pan limits
       - Layer management (ZStack):
         - [x] Grid layer (back):
           - Dots at corners of 44×44pt squares
           - Translucent gray dots
           - Scales with zoom
         - Board Items layer (middle)
         - Board UI layer (front)
       - Center origin:
         - Grid coordinate system has fixed (0,0) center
         - Position initial view to show center
         - Maintains center during zoom/pan
       - [x] Navigation/toolbar setup:
         - Left: Close button (✕)
         - Center: Board name (unique per show)
         - Right section (in order):
           - Undo button
           - Redo button
           - Mode toggle (play.fill/pencil)
       - SwiftUI Preview Development:
         - Show empty board state
         - Show board with sample items
         - Show edit vs play mode states
         - Show with different zoom levels

5. [x] Create interactive components:
   - Components/
     - [x] ObjectSelectionMenu.swift
       - Standard sheet/popover presentation
       - List of show objects:
         - Use standard iOS searchable modifier
         - Filter by ShowObjectType enum
         - No last-used type memory in v1
       - Shows preview of selected object
       - Standard cancel/confirm actions
       - SwiftUI Preview Development:
         - Show with sample show objects
         - Show filtered state
         - Show search state
         - Show empty state

6. [x] Create board items:
   - Views/
     - [x] BoardItemView.swift
       - Rectangle rendering (not just square)
       - Minimum 44×44pts (1×1 grid)
       - Color comes from the related ShowObject
       - Name comes from the related ShowObject
       - Number and Type also comes from the related ShowObject
       - Edit mode:
         - Drag to move (grid-snapped)
         - Resize handles on corners for dragging
         - Maintains minimum 44×44pts (1×1 grid unit) during resize
         - Context menu (reassign/remove)
         - Shows error on overlap ("You cannot overlap items")
       - Play mode:
         - Tap to trigger
         - iOS standard feedback (highlight/pressed animation)
         - Standard haptic feedback
       - SwiftUI Preview Development:
         - Show different sizes
         - Show edit mode state
         - Show play mode state
         - Show error state
         - Show with resize handles

## 2. Board Management
1. [x] Implement basic board list:
   - Setup BoardListView:
     - Create list layout
     - Connect to show's boards
     - Handle empty state
     - SwiftUI Preview Development:
       - Use the mock repositories and adjust them if they need to be adjusted for previews
       - Show with sample boards
       - Show empty state
   - Setup navigation:
     - Handle board selection
     - Preserve navigation state
     - Restore board state on return

2. [x] Create board creation flow:
   - Add creation UI:
     - "New Board" button
     - Name input dialog
     - Validate name (non-empty, unique)
   - Handle creation:
     - Create BoardEntity
     - Save via repository
     - Navigate to new board in a full screen cover
     - Start in edit mode
     - Set default zoom/position

3. [x] Add board actions:
   - Implement rename:
     - Add rename swipe action
     - Show rename dialog
     - Validate new name
     - Update via repository
   - Implement delete:
     - Add delete swipe action
     - Show confirmation dialog
     - Delete via repository
     - Clean up related items
     - Handle navigation after delete

## 3. Core Board Implementation
1. [ ] Connect state management:
   - Wire ViewModel to views:
     - Bind zoom/pan state to transforms
     - Bind edit mode to grid visibility
     - Use standard SwiftUI @State/@Environment using Observation
   - Connect persistence:
     - Save state through repository
     - Repository handles notifications
     - Restore last position/zoom on load
   - Setup edit mode undo:
     - Register state changes in edit mode
     - Clear undo stack on mode exit

2. [ ] Implement pan functionality:
   - Connect drag gesture to BoardState:
     - Update contentOffset in BoardState via ViewModel
     - Use standard SwiftUI drag gesture
     - Track pan position for infinite scrolling
   - Wire view hierarchy transforms:
     - Apply content offset from BoardState
     - Maintain (0,0) center origin during transforms

3. [ ] Implement zoom functionality:
   - Setup zoom gesture coordination:
     - Add MagnificationGesture to BoardView's ScrollView
     - Handle gesture state updates (.onChanged, .onEnded)
     - Prevent gesture conflicts with scroll/pan
   - Implement zoom transforms:
     - Apply CGAffineTransform for scaling
     - Maintain scroll position during zoom
     - Keep (0,0) at center during zoom
     - Handle zoom anchor point correctly
   - Connect zoom to state:
     - Update BoardState.zoomLevel through ViewModel
     - Scale grid relative to zoom value
     - Save zoom state via repository
   - Add zoom animations:
     - Smooth transitions between zoom levels
     - Maintain grid visibility during zoom
     - Handle zoom momentum/velocity

## 4. Object Placement System
1. [ ] Create placement gesture system:
   - Setup drag gesture:
     - Add DragGesture to BoardView
     - Track start position (snapped to grid)
     - Update size during drag (snapped to grid)
     - Handle gesture end
   - Add visual feedback:
     - Show rectangle during drag
     - Gray when valid, red when invalid
     - Snap corners to grid points
   - Implement validation:
     - Check minimum size (44×44, 1×1 grid)
     - Check for overlaps with existing items
     - When drag ends:
       - Remove rectangle
       - Show error toast if invalid
       - Show selection menu if valid
   - SwiftUI Preview Development:
     - Use the mock repositories and adjust them if they need to be adjusted for previews
     - Show drag in progress
     - Show valid vs invalid states
     - Show with different size rectangles
     - Show with grid snapping

2. [ ] Implement object selection menu:
   - Setup menu presentation:
     - Show as sheet/popover after valid drag
     - Grid layout of available show objects
     - Use standard iOS searchable modifier
     - Filter by ShowObjectType enum
     - No last-used type memory in v1
     - Load available show objects
     - Handle menu dismissal
   - Implement object selection:
     - Filter objects by type
     - Search object names
     - Create BoardItemEntity on selection
     - Clean up if cancelled
   - SwiftUI Preview Development:
     - Use the mock repositories and adjust them if they need to be adjusted for previews
     - Show grid with sample show objects
     - Show with search active
     - Show filtered by different types
     - Show empty search results

## 5. Edit Mode Features
1. [ ] Implement object manipulation:
   - Setup drag movement:
     - Add DragGesture to BoardItemView
     - Track item position
     - Snap to grid during movement
     - Update position in BoardState via ViewModel
   - Add resize handling:
     - Create corner resize handles
     - Track resize gesture
     - Maintain minimum 44×44pts (1×1 grid unit)
     - Never allow existing items below 1×1
     - Snap to grid during resize
     - Update size in BoardState
     - For existing items:
       - Block resize if would go below 1×1
       - Keep current size if attempt made
       - No deletion on small resize
   - Implement validation:
     - Check for overlaps during drag/resize
     - Show red highlight when invalid
     - Revert to previous position if invalid
     - Show error toast on invalid placement

2. [ ] Add context menu:
   - Setup menu trigger:
     - Add long press gesture
     - Show standard context menu
   - Implement actions:
     - Add reassign action:
       - Open object selection menu
       - Update BoardItemEntity on selection
       - Handle cancellation
     - Add delete action:
       - Remove from BoardState
       - Clean up via repository
     - Add visual feedback:
       - Standard iOS menu highlights
       - Haptic feedback on action
   - SwiftUI Preview Development:
     - Show menu closed state
     - Show menu open state

## 6. Play Mode Features
1. [ ] Implement mode-specific behaviors:
   - Setup gesture disabling:
     - Disable drag movement
     - Disable resize handles
     - Disable context menu
     - Keep pan/zoom enabled
   - Hide grid

2. [ ] Implement trigger system:
   - Setup tap handling:
     - Add TapGesture to BoardItemView
     - Ensure single tap recognition
     - Prevent gesture conflicts
   - Add feedback:
     - Standard iOS tap highlight
     - Haptic feedback on trigger
     - Brief scale animation
   - Connect triggers:
     - Send show object command
     - Handle trigger completion
     - Handle trigger errors
   - SwiftUI Preview Development:
     - Use the mock repositories and adjust them if they need to be adjusted for previews
     - Show tap recognition states
     - Show feedback animations
     - Show error states
     - Show success states

## 7. Board Preview Implementation
1. [ ] Create thumbnail generation:
   - Implement board snapshot renderer:
     - Capture visible board area
     - Scale to thumbnail size
     - Show object squares without names
   - Add generation triggers:
     - On board creation
     - After object changes (add/move/resize/remove)
     - Before list display
   - Add caching system for performance
   - SwiftUI Preview Development:
     - Use the mock repositories and adjust them if they need to be adjusted for previews
     - Show different board states as thumbnails
     - Show different sizes

2. [ ] Add previews to board list:
   - Update BoardListView layout
   - Add thumbnail display
   - Handle loading states
   - Update on changes

## 8. Analytics
1. [ ] Add board management events:
   - Track board creation:
     - Board name
     - Show ID
     - Creation timestamp
   - Track board deletion:
     - Board ID
     - Item count at deletion
     - Deletion timestamp
   - Track board rename
   - Track board opens/views

2. [ ] Add object events:
   - Track object placement:
     - Object type
     - Size
     - Position
   - Track object deletion
   - Track object reassignment
   - Track object resizing
   - Track object moves

3. [ ] Add interaction events:
   - Track mode switches (edit/play)
   - Track object triggers in play mode
   - Track trigger errors/failures
