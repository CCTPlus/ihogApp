# iHog

An iOS app that lets you control your [Hog console](https://www.etcconnect.com/Hog/) remotely. iHog brings professional lighting control to your fingertips, designed for lighting technicians and operators who use ETC Hog consoles.

## Technologies

- SwiftUI for the user interface
- OSC (Open Sound Control) for console connectivity
- SwiftData for data persistence
- CloudKit for data synchronization
- iOS 17+ native frameworks

## Features

- Control palettes and groups
- Access go lists and scenes
- Use console's hardware controls
- Sync between iOS Devices
- Unlimited shows (Pro feature)
- Custom icons for shows (Pro feature)
- Punt Page (Pro feature)
- Continuous updates and bug fixes

## Requirements

### System Requirements
- iOS 17.0 or later
- Xcode 16.0 or later for development
- [Node.js](https://nodejs.org) for git hooks
- Network connectivity for console communication

### Dependencies
- Git for version control
- Husky for git hooks

## Installation and Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/iHog.git
   cd iHog
   ```

2. Install development dependencies:
   ```bash
   npx husky install
   ```

3. Open `iHog.xcodeproj` in Xcode
   - We recommend using [Xcodes app](https://github.com/XcodesOrg/XcodesApp) to manage Xcode versions

4. Build and run the project

## Project Structure

```
iHog/
├── Data/              # Data persistence and models
├── Features/          # Core feature implementations
├── Model/             # Data models
├── Analytics/         # Analytics tracking
├── Views/             # UI components and screens
├── State/             # App state management
├── Helpers/           # Utility functions and constants
├── FeatureFlags/      # Feature flag management
├── Assets.xcassets/   # App assets and resources
└── Preview Content/   # SwiftUI preview content
```

## Usage

1. Launch the app on your iOS device
2. Connect to your Hog console
   - Ensure both devices are on the same network
   - Follow Hog instructions on how to connect Open Sound Control

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

For major changes, please open an issue first to discuss the proposed changes.

## License

This project is licensed under the Apache License - see the [LICENSE](./LICENSE) file for details.

## Acknowledgments

- [ETC Hog](https://www.etcconnect.com/Hog/) for console specifications
- The lighting design community for feedback and support