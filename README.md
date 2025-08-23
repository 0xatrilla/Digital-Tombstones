# KilledByGoogle - iOS App

A modern iOS application that showcases Google's discontinued products and services. Built with SwiftUI and targeting iOS 26+, this app provides an elegant way to browse the "Google Graveyard" - products that were killed by Google over the years.

## Features

### 📱 Core Functionality
- **Browse Discontinued Products**: Explore Google's discontinued apps, services, and hardware
- **Search & Filter**: Find products by name, description, type, or year discontinued
- **Favorites System**: Save your favorite discontinued products for quick access
- **Multiple View Layouts**: Switch between list and grid layouts with customizable density
- **Product Details**: View detailed information about each discontinued product

### 🎨 Design & Customization
- **Dynamic Backgrounds**: Choose from Liquid Gradient, Ocean, Sunset, or Solid themes
- **Typography Options**: System, Rounded, Serif, or Monospaced font choices
- **Responsive Design**: Optimized for all iPhone screen sizes
- **Accessibility Support**: Full VoiceOver and Dynamic Type support

### ⚡ Modern iOS Features
- **SwiftUI Interface**: Built entirely with SwiftUI for smooth performance
- **iOS 26+ APIs**: Leverages the latest iOS capabilities
- **Swift Concurrency**: Modern async/await patterns throughout
- **Pull-to-Refresh**: Keep data fresh with pull-to-refresh gesture
- **Context Menus**: Long-press for quick actions (favorite, share, copy link)

## Screenshots

*Screenshots will be added here showing the main interface, detail views, and settings*

## Technical Details

### Architecture
- **Modern SwiftUI**: Pure SwiftUI with Model-View (MV) architecture
- **No ViewModels**: Uses SwiftUI's native state management (@State, @Observable, @Environment)
- **Swift Package Manager**: Modular architecture with SPM packages
- **Workspace Structure**: Clean separation between app shell and feature code

### Requirements
- **iOS**: 26.0 or later (with optional iOS 26.0 features)
- **Xcode**: 26.0 or later
- **Swift**: 6.1 or later
- **Device**: iPhone (optimized for all screen sizes)

### Data Source
The app fetches real-time data from the official [Killed by Google](https://killedbygoogle.com) project repository, ensuring you always have the latest information about Google's discontinued products.

## Project Structure

```
KilledByGoogle/
├── KilledByGoogle.xcworkspace/              # Open this file in Xcode
├── KilledByGoogle.xcodeproj/                # App shell project
├── KilledByGoogle/                          # App target (minimal)
│   ├── Assets.xcassets/                # App-level assets (icons, colors)
│   ├── KilledByGoogleApp.swift              # App entry point
│   └── KilledByGoogle.xctestplan            # Test configuration
├── KilledByGooglePackage/                   # 🚀 Primary development area
│   ├── Package.swift                   # Package configuration
│   ├── Sources/KilledByGoogleFeature/       # Your feature code
│   └── Tests/KilledByGoogleFeatureTests/    # Unit tests
└── KilledByGoogleUITests/                   # UI automation tests
```

## Key Architecture Points

### Workspace + SPM Structure
- **App Shell**: `KilledByGoogle/` contains minimal app lifecycle code
- **Feature Code**: `KilledByGooglePackage/Sources/KilledByGoogleFeature/` is where most development happens
- **Separation**: Business logic lives in the SPM package, app target just imports and displays it

### Buildable Folders (Xcode 16)
- Files added to the filesystem automatically appear in Xcode
- No need to manually add files to project targets
- Reduces project file conflicts in teams

## Development Notes

### Code Organization
Most development happens in `KilledByGooglePackage/Sources/KilledByGoogleFeature/` - organize your code as you prefer.

### Public API Requirements
Types exposed to the app target need `public` access:
```swift
public struct NewView: View {
    public init() {}
    
    public var body: some View {
        // Your view code
    }
}
```

Remember to mark types as `public` when they need to be accessed by the app target.

### Testing

Run tests using:
- **Unit Tests**: ⌘+U in Xcode or `swift test` in the package directory
- **UI Tests**: Select the UI test scheme and run

Tests use the modern Swift Testing framework with `@Test` attributes and `#expect` assertions.

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes in the `KilledByGooglePackage` directory
4. Add tests for new functionality
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Code Style

- Follow Swift API Design Guidelines
- Use SwiftUI's declarative patterns
- Prefer `struct` over `class` for data models
- Use `async/await` for asynchronous operations
- Write tests for new functionality

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- **[Killed by Google](https://killedbygoogle.com)** - Original project and data source by Cody Ogden
- **Apple** - For the amazing SwiftUI and iOS development tools
- **Community** - For various open source packages and inspiration

## Privacy

This app:
- ✅ Does not collect personal information
- ✅ Does not use analytics or tracking
- ✅ Stores favorites locally on device only
- ✅ Only fetches public data from the Killed by Google API

## Support

If you encounter any issues or have suggestions:
- Open an issue on GitHub
- Check existing issues first
- Provide detailed reproduction steps
- Include iOS version and device model

---

**Note**: This app is not affiliated with Google Inc. It's a community project that visualizes publicly available information about Google's discontinued products.
