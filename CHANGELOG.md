## 1.0.0
* First stable version with comprehensive features and optimizations
* Complete English translation of documentation and API references
* Significantly improved WebView performance with reduced memory usage
* Enhanced controller features including better direction tracking and camera animations
* Comprehensive error handling system with detailed logs and stability improvements
* Simplified URL-based map configuration for easier integration
* Added full documentation for all classes, methods, and properties

## 0.1.4
* Fixed critical rendering bug affecting iOS devices with notches
* Improved map loading logic to handle poor network connections
* Optimized memory usage during map transitions
* Enhanced JavaScript communication between Flutter and WebView

## 0.1.3
* Fixed map marker rendering issue on certain Android devices
* Improved error handling for network connection problems
* Added better fallback mechanism for style loading failures

## 0.1.2
* Added support for dynamic URL structure - now parameters like #zoom/lat/lng/bearing/tilt are optional for more flexible configuration
* Added ability to customize the order of parameters in map URL to match different map provider formats
* Added advanced features for camera control (tilt, bearing) with smooth animation support
* Added user direction tracking feature with compass calibration improvements
* Added new features and methods to MapController for better programmatic control
* Improved error messages and debugging support

## 0.1.1
* Updated YAML configuration for better package compatibility
* Fixed dependencies to ensure compatibility with latest Flutter versions
* Improved package metadata for better discoverability

## 0.1.0
* Returned to WebView implementation for better performance and feature support
* Completely refactored core components for stability
* Added support for latest WebView Flutter features
* Improved JavaScript bridge implementation

## 0.0.9
* Added comprehensive fix for "unregistered_view_type" error on iOS platform with automatic detection
* Added `FlutterMapGLPlatform` class - iOS platform registration issues are automatically resolved without manual intervention
* Added platform initialization support in the main function of projects using the package for smoother startup
* Improved documentation - added detailed solution guides for issues encountered on iOS platform with step-by-step instructions
* Optimized platform view initialization process for faster map loading and reduced flickering

## 0.0.8
* Switched from webview package to inappwebview for better performance and feature support
* Added support for more JavaScript APIs and events
* Fixed various rendering issues on iOS devices
* Improved gesture handling and responsiveness

## 0.0.7
* Fixed critical PlatformException issue on iOS devices that caused crashes
* Added a simpler URL-based approach instead of WebView for environments with limited WebView support
* Added comprehensive support for parsing map parameters from URL (zoom, lat, lng, bearing, tilt) with validation
* Added support for flexible URL format like "https://www.your_map_url.com/zoom/lat/lon/bearing/tilt"
* Updated example app with new features and improved UI demonstrations

## 0.0.6
* WebView Flutter package updated to latest version (4.11.0) with significant performance improvements
* Ensured WebView controller is held globally to prevent memory leaks and improve stability
* Added special solution for channel error on iOS platform that affected communication
* Improved WebView lifecycle management with proper disposal and recreation
* Made JavaScript communication more stable with better error handling and retry mechanisms

## 0.0.5
* Improved iOS and Android WebView configurations for better performance and compatibility
* Fixed critical PlatformException error that caused crashes on certain devices
* Enhanced error handling with detailed error messages and recovery options
* Updated WebView Flutter package to compatible version to resolve dependency conflicts

## 0.0.4
* Added WebView-based map support with full gesture handling
* Added comprehensive support for displaying real web maps in mobile applications with native-like experience
* Added JavaScript-Flutter map communication with bidirectional event system
* Extended MapController class with new methods and added ChangeNotifier implementation for reactive UI updates
* Updated documentation with examples and best practices for integration

## 0.0.3
* Fixed floating action button hero tag collision that caused animation glitches
* Improved widget tree structure for better performance
* Added proper key handling for widget identification

## 0.0.2
* Removed web support, focusing exclusively on mobile platforms (iOS and Android) for better performance
* Improved mobile integration with platform-specific optimizations
* Significant performance improvements for map rendering and interaction
* Reduced package size and dependencies

## 0.0.1
* Initial release with basic map functionality
* Support for simple map display and interaction
* Foundation for future feature development
