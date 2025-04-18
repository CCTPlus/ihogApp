General guidance on SwiftUI view:

- Each view or component must have it's own file.
- Each view or component must have Previews. If there are multiple states, then there must be a preview for each state.
- Previews must use the mock repository
- Views should be folling an MVVM pattern and using the observation framework
- ViewModels should always handle all the logic. There should be little to no logic in the views. 

General guidance on coding:
- Comments need to be added for each significant piece of code explaining what it does
- All models must be fetched using the repository architecture. Each repository has a protcol so that must be adjusted first.
- Coding style must match the style of other files in the app.

Guidence about the project:
- The app uses a repository architecture to manipulate and fetch items from SwiftData.
- Entities or managed objects are NOT to be used in views. Only non managed models can be used in views
- All source files live in Sources/iHog/iHog