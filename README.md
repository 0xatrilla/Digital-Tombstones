# KilledByGoogle - iOS App

A modern iOS application using a **workspace + SPM package** architecture for clean separation between app shell and feature code.

## Project Architecture

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

### Adding Dependencies
Edit `KilledByGooglePackage/Package.swift` to add SPM dependencies:
```swift
dependencies: [
    .package(url: "https://github.com/example/SomePackage", from: "1.0.0")
],
targets: [
    .target(
        name: "KilledByGoogleFeature",
        dependencies: ["SomePackage"]
    ),
]
```

### Test Structure
- **Unit Tests**: `KilledByGooglePackage/Tests/KilledByGoogleFeatureTests/` (Swift Testing framework)
- **UI Tests**: `KilledByGoogleUITests/` (XCUITest framework)
- **Test Plan**: `KilledByGoogle.xctestplan` coordinates all tests

## Configuration

### XCConfig Build Settings
Build settings are managed through **XCConfig files** in `Config/`:
- `Config/Shared.xcconfig` - Common settings (bundle ID, versions, deployment target)
- `Config/Debug.xcconfig` - Debug-specific settings  
- `Config/Release.xcconfig` - Release-specific settings
- `Config/Tests.xcconfig` - Test-specific settings

### Entitlements Management
App capabilities are managed through a **declarative entitlements file**:
- `Config/KilledByGoogle.entitlements` - All app entitlements and capabilities
- Edit this XML file directly to add capabilities like HealthKit, CloudKit, Push Notifications, etc.
- No need to modify complex Xcode project files

### Asset Management
- **App-Level Assets**: `KilledByGoogle/Assets.xcassets/` (app icon, accent color)
- **Feature Assets**: Add `Resources/` folder to SPM package if needed

### SPM Package Resources
To include assets in your feature package:
```swift
.target(
    name: "KilledByGoogleFeature",
    dependencies: [],
    resources: [.process("Resources")]
)
```

### Generated with XcodeBuildMCP
This project was scaffolded using [XcodeBuildMCP](https://github.com/cameroncooke/XcodeBuildMCP), which provides tools for AI-assisted iOS development workflows.