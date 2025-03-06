# HeroRandomizer App

## Overview
HeroRandomizer is an iOS application that fetches and displays random superheroes from the Superhero API. The app demonstrates integration of SwiftUI within a UIKit project, network requests, data modeling, and modern UI design.

## Features
- Random superhero generator with a simple press of a button
- Detailed view showing comprehensive hero information
- Clean, card-based UI design
- Proper loading and error handling states

## Technical Implementation

### Architecture
The app uses a hybrid architecture combining UIKit and SwiftUI:
- UIKit serves as the foundation (AppDelegate, SceneDelegate)
- SwiftUI provides the user interface components
- MVVM pattern with `HeroViewModel` managing the data flow

### Core Components
1. **UIKit Integration**
   - Project setup as a UIKit application
   - SwiftUI views integrated using UIHostingController
   - Navigation handled through SwiftUI's NavigationView

2. **Network Layer**
   - `NetworkManager` class handles API requests using Combine
   - Custom error handling with user-friendly messages
   - Proper decoding of JSON data into Swift models

3. **Data Models**
   - Structured models representing superhero data
   - Full conformance to Codable for JSON parsing
   - Organized into logical components (PowerStats, Biography, etc.)

4. **UI Design**
   - Clean card-based interface with a light color scheme
   - Simple progress bars for power statistics
   - Responsive layout that works on various iOS devices
   - Detailed sections for organizing hero information

## Implementation Decisions

### Why UIKit + SwiftUI Hybrid?
While SwiftUI offers many advantages, the assignment specifically required integration of SwiftUI within a UIKit project. This approach:
- Demonstrates understanding of both frameworks
- Shows how to bridge between UIKit and SwiftUI
- Represents a common real-world scenario of adopting SwiftUI in existing UIKit apps

### UI Design Choices
- **Card-based layout**: Provides a clean separation of content and improves readability
- **Progress bars for stats**: Offers visual representation of hero attributes
- **Light color scheme**: Ensures good contrast and readability
- **Minimal animations**: Focuses on responsiveness and clarity

### Error Handling
The app implements comprehensive error handling:
- Network errors with user-friendly messages
- Loading states to indicate data retrieval
- Fallbacks for missing data values

### Code Organization
The code is organized into logical components:
- Network layer for API communication
- Data models for structured information
- View models for business logic
- UI components for presentation

## Requirements
- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## How to Run
1. Clone the repository
2. Open the project in Xcode
3. Select a simulator or device
4. Build and run the application

## Future Improvements
While the current implementation satisfies all the requirements, future enhancements could include:
- Favorites system to save preferred heroes
- Search functionality to find specific heroes
- More detailed hero comparisons
- Offline caching of hero data
