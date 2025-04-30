<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Flutter Map GL

Flutter Map GL is a Flutter package that allows you to display existing web maps in mobile applications (iOS and Android) using WebView.

## Features

- Display web maps in mobile applications (iOS and Android) using WebView
- Support for 3D maps (zoom, bearing, pitch/tilt)
- Perform operations on the map with a map controller
- Listen to map events (click, movement, etc.)
- URL-based map configuration

## Getting Started

To add the package to your project, add the following lines to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_map_gl: ^1.0.0
  webview_flutter: ^4.11.0
```

Then install the dependencies:

```bash
flutter pub get
```

## Usage

For basic map display:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map_gl/flutter_map_gl.dart';

class MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterMapGL(
      options: MapOptions(
        center: LatLng(41.0082, 28.9784), // Istanbul
        style: 'https://your-map-server.com/map-style/',
        zoom: 11.0,
        bearing: 0.0,    // Map rotation (0-360 degrees)
        pitch: 45.0,     // Map tilt (0-60 degrees)
      ),
    );
  }
}
```

To perform operations with the map controller:

```dart
final MapController controller = MapController();

FlutterMapGL(
  options: MapOptions(
    center: LatLng(41.0082, 28.9784), // Istanbul
    style: 'https://your-map-server.com/map-style/',
    zoom: 11.0,
    bearing: 0.0,
    pitch: 45.0,
  ),
  controller: controller,
  onMapCreated: () {
    print('Map created!');
  },
  onMapClick: (latLng) {
    print('Map clicked: $latLng');
  },
  onCameraMove: (position, zoom) {
    print('Camera movement: $position, Zoom: $zoom');
  },
)

// Move the map
controller.moveCamera(LatLng(41.01, 28.98), zoom: 15.0);

// Change zoom level
controller.setZoom(12.0);

// Change map style
controller.setStyle('https://your-map-server.com/different-style/');
```

## WebView and 3D Map Integration

This package is designed to display 3D maps from your server within a WebView. Your map's JavaScript API should support the following features:

```javascript
// Add event listeners after map loading
map.on('click', function(e) {
  const lat = e.lngLat.lat;
  const lng = e.lngLat.lng;
  // Send click information to Flutter
  MapChannel.postMessage('click:' + lat + ',' + lng);
});

// Notification after map movement
map.on('moveend', function() {
  const center = map.getCenter();
  const zoom = map.getZoom();
  // Send camera movement information to Flutter
  MapChannel.postMessage('move:' + center.lat + ',' + center.lng + ',' + zoom);
});

// Method to change zoom
map.setZoom(14.5);

// Change bearing (compass)
map.setBearing(45);

// Change pitch (tilt)
map.setPitch(60);
```

## URL-Based Map Configuration

Flutter Map GL can extract map parameters from a URL. This allows you to manage your map configuration with a single URL:

```dart
// URL format: baseUrl#zoom/lat/lng/bearing/tilt
final String mapUrl = "https://your-map-server.com/styles/main-style/#16.96/37.872351/32.492013/-36.9/60";

// Create map options from URL
final mapOptions = MapOptions.fromUrl(mapUrl);

// Display the map
FlutterMapGL(
  options: mapOptions,
  controller: controller,
)
```

## Android Manifest Permissions

Make sure to add the following permissions to your Android application's AndroidManifest.xml file:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

If you will use location services, also add these permissions:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

## iOS Info.plist Definitions

Make sure to add the following definitions to your iOS application's Info.plist file:

```xml
<key>io.flutter.embedded_views_preview</key>
<true/>

<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

If you will use location services:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location permission is required to use map features</string>
```

## Platform Support

| Platform | Status |
| -------- | ----- |
| Android | ✅ Supported |
| iOS | ✅ Supported |

## Performance Tips

Since 3D maps require high performance, consider the following tips:

1. Add a loading indicator while the WebView is loading
2. Adjust map quality according to device performance
3. Load large maps with lazy loading
4. Dispose of WebView when the map is not visible
5. Use separate WebView configurations for Android and iOS

## Example Use Cases

- Displaying custom 3D city models
- Game-like mapping systems
- Architectural and terrain visualization
- Virtual tour and navigation applications
- Customized thematic maps

## Contributing

If you would like to contribute, please open a Pull Request or create an Issue.

## License

This package is licensed under the MIT license.

## iOS WebView Issue Solution

If you are experiencing a `PlatformException (PlatformException(channel-error, Unable to establish connection on channel...` error related to WebView on iOS platform, follow these steps:

1. Explicitly specify the webview_flutter package in your application's pubspec.yaml file:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_map_gl: ^1.0.0
  webview_flutter: ^4.11.0  # Specifying the same version is important
```

2. Add the following settings to your iOS project's `ios/Runner/Info.plist` file:
```xml
<key>io.flutter.embedded_views_preview</key>
<true/>

<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

3. Rebuild your iOS application:
```bash
flutter clean
cd ios
pod install
cd ..
flutter run -d ios
```

4. Manage the application lifecycle correctly - Properly handle state management to prevent issues when your application is sent to the background and the WebView is closed and reopened.

## URL-Based Map Usage

Flutter Map GL can now extract map parameters directly from a URL. This provides a solution especially for WebView issues on iOS.

```dart
// URL format: baseUrl#zoom/lat/lng/bearing/tilt
final String mapUrl = "MAP_URL";

// Create map options from URL
final mapOptions = MapOptions.fromUrl(mapUrl);

// Display the map
FlutterMapGL(
  options: mapOptions,
  controller: controller,
  onMapCreated: () {
    print('Map created!');
  },
  onMapClick: (latLng) {
    print('Map clicked: $latLng');
  },
)
```

This approach prevents WebView channel errors on iOS platform and allows you to display your map directly with the URL parameters you specify (zoom, latitude, longitude, bearing, tilt).

## Documentation

### Classes

#### `FlutterMapGL`

The main widget that displays the map.

```dart
FlutterMapGL({
  required MapOptions options,
  MapController? controller,
  Function? onMapCreated,
  Function(LatLng)? onMapClick,
  Function(LatLng, double)? onCameraMove,
})
```

#### `MapOptions`

Contains configuration options for the map.

```dart
MapOptions({
  required LatLng center,
  required String style,
  double zoom = 10.0,
  double bearing = 0.0,
  double pitch = 0.0,
})
```

Factory method to create options from URL:

```dart
MapOptions.fromUrl(String url)
```

#### `MapController`

Controls the map view.

```dart
// Methods
void moveCamera(LatLng position, {double? zoom});
void setZoom(double zoom);
void setBearing(double bearing);
void setPitch(double pitch);
void setStyle(String styleUrl);
void followUserLocation(bool follow);
```

#### `LatLng`

Represents a geographical point with latitude and longitude coordinates.

```dart
LatLng(double lat, double lng)
```

### Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map_gl/flutter_map_gl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _controller = MapController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Map GL Example')),
      body: FlutterMapGL(
        options: MapOptions(
          center: LatLng(51.509865, -0.118092), // London
          style: 'https://your-map-server.com/style',
          zoom: 13.0,
          bearing: 0.0,
          pitch: 0.0,
        ),
        controller: _controller,
        onMapCreated: () {
          print('Map is ready');
        },
        onMapClick: (latLng) {
          print('Clicked at: $latLng');
        },
        onCameraMove: (position, zoom) {
          print('Camera moved to: $position with zoom: $zoom');
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _controller.setZoom((_controller.zoom ?? 10) + 1),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            child: Icon(Icons.remove),
            onPressed: () => _controller.setZoom((_controller.zoom ?? 10) - 1),
          ),
        ],
      ),
    );
  }
}
```
