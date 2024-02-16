---
title: Naming Conventions
description: Explanation of naming conventions used in the code.
---

## SwiftUI Components

### `Screen` vs `View`

When making a SwiftUI view, be mindful about naming. A `Screen` suffix is used when the view is the top level view and manages what's below it. For example, `ProgrammingObjectsScreen` handles which smaller view is being shown. A `View` suffix is used when it's a component or a container view.