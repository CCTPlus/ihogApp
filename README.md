# iHog App

## Project setup

### Prerequisites

- [Node.js](https://nodejs.org) is needed for git hooks
- Xcode 16 (@heyjaywilson suggests using the [Xcodes app](https://github.com/XcodesOrg/XcodesApp) to manage Xcode versions)
- [swift-format](https://github.com/apple/swift-format#getting-swift-format)

### Steps

1. Clone the repo
2. Navigate into the repo via the command line
3. Run `npx husky install` to install git hooks
4. Setup secrets file by duplicating the `Secrets.example.json` and rename it to `Secrets.json`. Use `00000000-0000-0000-0000-000000000000` as the value for `telemetry_deck_key`