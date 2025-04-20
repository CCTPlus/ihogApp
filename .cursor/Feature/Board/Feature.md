# iHog Board Feature Spec

## Initial feautre release

### Feature: Infinite Board for Show Objects

### 1. Overview

This feature adds a freeform, zoomable, and scrollable board to iHog on iPad and iPhone. Users can visually organize and trigger show objects (groups, palettes, lists, scenes) by placing them as square blocks on the board. The board supports both edit and play modes, enabling layout customization and live triggering.

### 2. Supported Show Objects

All Show Objects and show object types will be supported. Here's the data structure and object types:

```swift
@Model final class ShowObjectEntity {
  var id: UUID?
  var isOutlined: Bool?
  var name: String?
  var number: Double? = 0.0
  var objColor: String?
  var objType: String?
  var showID: String?
  var show: ShowEntity?

  init(
    id: UUID = UUID(),
    isOutlined: Bool? = nil,
    name: String? = nil,
    number: Double? = nil,
    objColor: String? = nil,
    objType: String? = nil,
    showID: String? = nil,
    show: ShowEntity? = nil
  ) {
    self.id = id
    self.isOutlined = isOutlined
    self.name = name
    self.number = number
    self.objColor = objColor
    self.objType = objType
    self.showID = showID
    self.show = show
  }
}
```

Available object types are as follows:
```swift
public enum ShowObjectType: String {
  case group
  case intensity
  case position
  case color = "colour"
  case beam
  case effect

  case list
  case scene
  case batch

  // others
  case macro
  case plot
}
```

### 3. Board Behavior

- Infinite scrollable area in all directions
- No zoom or pan limits
- Board supports:
  - Drag to pan
  - Pinch to zoom
- No default board is loaded automatically; users explicitly select one
- Boards are tied to a specific show
- Multiple boards can exist per show
- Board names are:
  - User-defined (renameable)
  - Displayed on-screen

### 4. Object Placement

- Users tap anywhere on the board to begin placing an item
- A new item is created at the tapped location
- Default item size is **2×2 grid units** (88×88 pts)
- A selection menu immediately appears for assigning the object
- Placement is rejected if:
  - It overlaps with an existing object
- All object movement and resizing snaps to grid
- Objects can be any rectangular size (width × height) as long as each dimension is at least 1 grid unit

### 5. Interaction Modes

Tapping an object in Play Mode provides standard iOS visual feedback (e.g., highlight or pressed animation) to indicate the interaction occurred.

If a move or resize action would result in overlap with another object, the action is rejected. The object snaps back to its last valid state, and a message appears saying "You cannot overlap items."

In **Play Mode**, only tap-to-trigger, zooming, and panning are allowed. All other interactions — including dragging, resizing, or long-press — are disabled.

#### Edit Mode

- Board is editable
- Tapping on an object opens an edit menu with options to:
  - Reassign object
  - Remove object
  - Resize object (via drag handles)
- Objects are draggable and resizable
- Grid snap is enforced

#### Play Mode

- Board is live
- Tapping a square sends the assigned command to the connected device
- No edit options are available

For existing objects:
- Cannot be resized below 1×1 grid unit (44×44 pts)
- Attempts to resize below minimum will be blocked (object keeps current size)
- No deletion occurs from attempting to resize too small

### 6. Persistence

- Board layout is saved per show
- Multiple boards are supported per show
- All board data is saved via SwiftData
- Sync enabled via CloudKit

### 7. Undo / Redo

- The following actions are undoable/redone **within the current Edit Mode session only**:
  - Object added
  - Object moved
  - Object resized
  - Object reassigned
  - Object removed
- Leaving Edit Mode clears the undo/redo history
- Board zoom/pan is not included in undo history

### 8. Grid System

#### Grid Units

- 1 grid unit = 44×44 points
- All object placement, movement, and resizing snaps to these units
- Minimum object size = 2×2 grid units (88×88 pts)

#### Grid Visibility

- Grid is always visible in Edit Mode
- A toggle button allows the user to show/hide the grid
- Grid is hidden in Play Mode

#### Grid Style

- Grid appears as dots at the corners of each 44×44 square
- Dots are lightly colored (e.g. translucent gray), non-distracting

#### Grid Origin

- Grid origin is at the center of the board ((0, 0) in the middle)
- Supports infinite panning in all directions

#### Zoom Behavior

- Grid scales with zoom so grid units appear larger or smaller depending on zoom level

### 9. Board Switching

Board thumbnails are shown in the board list. These are rendered snapshots of each board area with the object squares. No need for names inside the preview thumbnails as they may be too small to read.

Board names must be non-empty and unique within the same show.

#### Access

- A dedicated tab bar icon is added for boards within an open show
- Tapping the board icon opens the board system for the current show

#### Board List UI

- Displays a full-screen selector with a list of all boards for the show
- Each entry includes the board name (thumbnail previews optional in future)
- A "+ New Board" button is available

#### Board Creation

- Tapping "New Board" prompts the user to name the board (default name pre-filled and editable)
- New boards open in **Edit Mode** by default

#### Board Switching Behavior

- Selecting a board opens it in full screen
- If the board already exists:
  - Opens in **Play Mode**
  - Restores **last used pan and zoom**
- If the board is new:
  - Opens in **Edit Mode**
  - Starts centered at origin

#### Deletion and Renaming

- Users can rename or delete boards via swipe or long-press actions
- Deletion is confirmed via a modal dialog


### 10. Menus and Object Interaction

#### Post-Placement Object Selection Menu

- After tapping to place a new object, a **popover menu** appears near the tapped location
- Menu includes:
  - **Search bar**
  - **Filters** for all object types
- User can cancel the menu to avoid placing anything
- (Note: remembering the last-used object type is not supported in the first version)

#### Edit Menu (Edit Mode Only)

- Tapping an existing object opens a **context menu**
- Menu options:
  - **Reassign** — opens the same object selection menu as above
  - **Remove** — deletes the object from the board
- Resizing is handled directly via **drag handles**, not through the menu

### 11. Data Modeling

If the linked ShowObjectEntity is deleted, the corresponding BoardItemEntity should also be deleted automatically.

All models below are SwiftData models and must support CloudKit syncing.

#### BoardEntity

Represents a saved board tied to a specific show.

- `id: UUID?` — unique identifier for the board
- `name: String?` — user-defined board name
- `showID: UUID?` — ID of associated ShowEntity
- `lastPanOffsetX: Double?` — x component of last visible offset when board was viewed
- `lastPanOffsetY: Double?` — y component of last visible offset when board was viewed
- `lastZoomScale: Double?` — last zoom scale used
- `items: [BoardItemEntity]?` — placed items on this board
- `show: ShowEntity?` — relationship to owning ShowEntity

#### BoardItemEntity

Represents a placed item on a board. Items can be show objects, encoders, front panel buttons, or playback bars. Position and size are stored in grid units relative to the board origin. All items are snapped to the nearest grid corner during placement, movement, or resizing.

- `id: UUID?` — unique identifier for the board item
- `boardID: UUID?` — ID of associated BoardEntity
- `itemType: String?` — type of board item ("showObject", "encoder", "frontPanel", "playback")
- `referenceID: UUID?` — ID of the referenced entity (ShowObjectEntity for show objects, or other entity types)
- `positionX: Double?` — x coordinate of the square relative to board center
- `positionY: Double?` — y coordinate of the square relative to board center
- `width: Double?` — width of the square in grid units (minimum 1)
- `height: Double?` — height of the square in grid units (minimum 1)
- `board: BoardEntity?` — relationship to owning BoardEntity

#### ShowEntity Updates

The ShowEntity has been updated to include a relationship to boards:

- `boards: [BoardEntity]?` — relationship to boards owned by this show


## Future considerations

- Allow for other items to be added like encoders, front panel buttons, and playback bars so items that are not `ShowObjectEntity`
- BoardItemEntity will need to be updated to include:
  - New `itemType` field to distinguish between show objects, encoders, front panel buttons, and playback bars
  - Rename `referenceID` to be more generic than just for show objects
  - Add additional fields for control-specific parameters
- BoardEntity will need its `objects` relationship renamed to `items` to reflect the more generic nature

