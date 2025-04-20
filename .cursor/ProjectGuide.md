# Project Guide

# Project Guide

This guide defines the required coding standards and architectural patterns for the iHog app. All rules must be followed without exception.

## File and Folder Structure

- All source files must be placed under: `Sources/iHog/iHog/`
- Each SwiftUI view, view model, model, entity, and repository must live in its own file
- Test files should mirror the source structure inside the appropriate test targets

## SwiftUI View Requirements

- Every view or component must be in its own file
- Every view must include a `#Preview` section
  - If a view has multiple states, each state must have its own preview
  - Previews that require data must use the mock repository
- Views must follow the MVVM pattern using the Observation framework
  - ViewModels must handle all logic; views should contain minimal to no business logic

## General Coding Standards

- Comments must be added for each significant block of code
  - Comments must explain what the code does, why it’s needed, and how it works
  - Avoid redundant comments. Do not restate what is obvious from naming.
    - For example, do not write: “The repository that fetches items”
    - Instead write: “Used to fetch and update item data”
- Code style must match the style used throughout the existing project

## Repository Architecture

- All data access must be done through the repository layer
- Each repository must:
  - Be defined as a protocol
  - Have a concrete implementation (e.g., `BoardSwiftDataRepository`)
  - Have a mock implementation for previews and tests
  - Mock implementations must allow for the objects to be passed in so that no objects can be in memory of any kind
- Entities (SwiftData-managed models) must never be used in views
  - Views must always use non-managed models (e.g., `Board.swift`, not `BoardEntity.swift`)

## Testing and Previews

- Unit tests must be created for:
  - All view models
  - All model types
  - All repository implementations and protocols
- Swift Testing should be used: https://developer.apple.com/documentation/testing/ **DO NOT USE XCTEST**
- Previews must represent real UI states using mock data and the mock repository

## Swift Data issues and ways to solve it

A predicate cannot reference values from a struct, so set those values as a constant before the predicate. See the example below
```swift
      // Board I want to find in the predicate
      let board = Board(name: "Test board")
      let boardID = board.id
        // Verify the update was persisted
        let descriptor = FetchDescriptor<BoardEntity>(
            predicate: #Predicate<BoardEntity> { $0.id == boardID }
        )
```