# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TCAWorks is a macOS SwiftUI application built using The Composable Architecture (TCA) pattern from Point-Free. The app appears to be a productivity application with features including calendar, mail, settings, and window management.

## Build Commands

```bash
# Build the project
xcodebuild -project TCAWorks.xcodeproj -scheme TCAWorks -configuration Debug build

# Run tests
xcodebuild -project TCAWorks.xcodeproj -scheme TCAWorks test

# Clean build
xcodebuild -project TCAWorks.xcodeproj -scheme TCAWorks clean

# Open in Xcode
open TCAWorks.xcodeproj
```

## Architecture

The project follows The Composable Architecture (TCA) pattern consistently:

### TCA Pattern Structure
Each feature module contains:
- **View**: SwiftUI view file (e.g., `CalendarMainView.swift`)
- **Reducer**: Business logic and state management (e.g., `CalendarMainReducer.swift`)
- **Types**: Type definitions and models (e.g., `CalendarTypes.swift`)

### Reducer Pattern
```swift
@Reducer
public struct FeatureReducer {
    @ObservableState
    public struct State: Equatable, Sendable {
        public struct ViewState: Equatable, Sendable { }
        public var viewState: ViewState = .init()
        // Child states
    }
    
    public enum Action: Equatable {
        case viewAction(ViewAction)
        // Child actions
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            // Handle actions
        }
        // Compose child reducers with Scope
    }
}
```

### Key Dependencies
- `swift-composable-architecture` (1.18.0) - Core TCA framework
- `swift-navigation` (2.3.0) - Navigation utilities
- `swift-dependencies` (1.8.1) - Dependency injection
- `swift-collections` (1.1.4) - Additional collection types

## Code Organization

```
TCAWorks/
├── Views/              # Feature modules (Calendar, Mail, Settings, Window)
├── UI/                 # Reusable UI components with their own reducers
├── Extensions/         # Type extensions for common operations
├── Utilities/          # Helper functions and utilities
└── Assets.xcassets/    # Images, colors, and app resources
```

## Development Guidelines

1. **State Management**: All state changes must go through reducers. Never modify state directly in views.

2. **Effects**: Side effects should be handled through TCA's `Effect` type in reducers.

3. **View Composition**: Parent views compose child views by passing scoped stores:
   ```swift
   ChildView(store: store.scope(state: \.childState, action: \.childAction))
   ```

4. **Testing**: When adding new features, create corresponding test files in `TCAWorksTests/` following TCA testing patterns.

5. **SwiftData Integration**: The app uses SwiftData for persistence. Models use `@Model` and views use `@Query` for data access.

6. **Localization**: The app supports Korean localization. String literals should use appropriate localization keys.

## Common Tasks

### Adding a New Feature
1. Create a new directory under `Views/` for your feature
2. Implement the reducer with `@Reducer` macro
3. Create the SwiftUI view with `WithViewStore`
4. Add navigation/presentation logic to parent views
5. Write tests for the reducer logic

### Modifying Existing Features
1. Locate the feature's reducer to understand state and actions
2. Make changes following the existing patterns
3. Ensure all state changes go through proper actions
4. Test the changes don't break parent/child reducer composition

### Working with UI Components
- Reusable components are in the `UI/` directory
- Each component typically has its own reducer for local state
- Components should be generic and not depend on specific features

## Current Development State

The project is on the `develop` branch with recent work on the Calendar feature. Recent changes include renaming and restructuring calendar-related files.