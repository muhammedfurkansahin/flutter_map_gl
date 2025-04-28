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

Flutter Map GL, mobil uygulamalarda (iOS ve Android) var olan web haritalarını WebView ile göstermenize olanak tanıyan bir Flutter paketidir.

## Özellikler

- Web haritalarını mobil uygulamalarda (iOS ve Android) WebView ile görüntüleme
- Harita kontrolcüsü ile harita üzerinde işlemler yapma
- Harita olaylarını dinleme (tıklama, hareket, vb.)

## Kurulum

Paketi `pubspec.yaml` dosyanıza ekleyin:

```yaml
dependencies:
  flutter_map_gl: ^latest_version
```

## Kullanım

### 1. Platform Başlatma

Uygulamanızın `main.dart` dosyasında, öncelikle platform başlatmasını yapmanız gerekiyor (özellikle iOS platformu için önemli):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map_gl/flutter_map_gl.dart';

void main() async {
  // Platform başlatma işlemi
  await FlutterMapGLPlatform().initialize();
  
  // Uygulamayı çalıştır
  runApp(const MyApp());
}
```

### 2. Harita Widget'ını Kullanma

Haritayı uygulamanızda kullanmak için:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map_gl/flutter_map_gl.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Map GL')),
      body: FlutterMapGL(
        options: MapOptions(
          style: 'https://yourmapapiurl.com',
          center: LatLng(41.0082, 28.9784),  // İstanbul
          zoom: 12.0,
        ),
        onMapCreated: () {
          print('Harita yüklendi');
        },
      ),
    );
  }
}
```

Harita kontrolcüsü ile işlemler yapmak için:

```dart
final MapController controller = MapController();

FlutterMapGL(
  options: MapOptions(
    center: LatLng(41.0082, 28.9784), // İstanbul
    style: 'https://your-map-server.com/map-style/',
    zoom: 11.0,
  ),
  controller: controller,
  onMapCreated: () {
    print('Harita oluşturuldu!');
  },
  onMapClick: (latLng) {
    print('Haritada tıklandı: $latLng');
  },
)

// Haritayı hareket ettirme
controller.moveCamera(LatLng(41.01, 28.98), zoom: 15.0);

// Yakınlaştırma seviyesini değiştirme
controller.setZoom(12.0);

// Harita stilini değiştirme
controller.setStyle('https://your-map-server.com/different-style/');
```

## WebView İletişimi

Bu paket, web haritasını WebView içinde gösterir. Haritadan Flutter'a veri göndermek için haritanızda JavaScript kanalı kullanabilirsiniz:

```javascript
// Harita JS kodunuzda:
function onMapClick(lat, lng) {
  // Flutter'a veri gönder
  FlutterMapGL.postMessage(JSON.stringify({
    event: 'click',
    lat: lat,
    lng: lng
  }));
}

function onMapLoaded() {
  // Flutter'a yükleme bilgisi gönder
  FlutterMapGL.postMessage(JSON.stringify({
    event: 'loaded'
  }));
}

// Kamera hareketi fonksiyonu (Flutter'dan çağrılır)
function moveCamera(lat, lng, zoom) {
  // Haritayı belirtilen konuma taşı
  map.setCenter([lng, lat]);
  map.setZoom(zoom);
}

// Zoom değiştirme fonksiyonu (Flutter'dan çağrılır)
function setZoom(zoom) {
  map.setZoom(zoom);
}
```

## Android Manifest İzinleri

Android uygulamanızın AndroidManifest.xml dosyasına aşağıdaki izinleri eklediğinizden emin olun:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

## iOS Info.plist Tanımları

iOS uygulamanızın Info.plist dosyasına aşağıdaki tanımları eklediğinizden emin olun:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Harita özelliklerini kullanabilmek için konum izni gerekiyor</string>

<key>io.flutter.embedded_views_preview</key>
<true/>
```

## Platform Desteği

| Platform | Durum |
| -------- | ----- |
| Android | ✅ Destekleniyor |
| iOS | ✅ Destekleniyor |

## Katkıda Bulunma

Katkıda bulunmak isterseniz, lütfen bir Pull Request açın veya bir Issue oluşturun.

## Lisans

Bu paket MIT lisansı altında lisanslanmıştır.

## iOS WebView Sorunu Çözümü

iOS platformunda WebView ile ilgili olarak `PlatformException (PlatformException(channel-error, Unable to establish connection on channel...` hatası alıyorsanız, aşağıdaki adımları izleyin:

1. Uygulamanızın pubspec.yaml dosyasında webview_flutter paketini açıkça belirtin:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_map_gl: ^0.0.7
  webview_flutter: ^4.11.0  # Aynı sürümü belirtmek önemli
```

2. iOS projenizin `ios/Runner/Info.plist` dosyasına aşağıdaki ayarları ekleyin:
```xml
<key>io.flutter.embedded_views_preview</key>
<true/>

<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

3. iOS uygulamanızı yeniden oluşturun:
```bash
flutter clean
cd ios
pod install
cd ..
flutter run -d ios
```

4. Uygulama yaşam döngüsünü doğru yönetin - Uygulamanız arka plana alındığında WebView'in kapatılıp tekrar açıldığında sorun çıkmaması için state yönetimini düzgün yapın.

## URL Tabanlı Harita Kullanımı

Flutter Map GL artık doğrudan URL'den harita parametrelerini çıkarabilir. Bu, özellikle iOS'taki WebView sorunlarına bir çözüm sunar.

```dart
// URL formatı: temelUrl#zoom/lat/lng/bearing/tilt
final String mapUrl = "https://inovision.tech/styles/klokantech-basic/#16.96/37.872351/32.492013/-36.9/60";

// URL'den harita seçeneklerini oluştur
final mapOptions = MapOptions.fromUrl(mapUrl);

// Haritayı göster
FlutterMapGL(
  options: mapOptions,
  controller: controller,
  onMapCreated: () {
    print('Harita oluşturuldu!');
  },
  onMapClick: (latLng) {
    print('Haritada tıklandı: $latLng');
  },
)
```

Bu yaklaşım, iOS platformunda yaşanan WebView kanal hatalarını önler ve haritanızı doğrudan belirttiğiniz URL parametreleriyle (zoom, enlem, boylam, bearing, tilt) görüntülemenizi sağlar.

## Sık Karşılaşılan Sorunlar ve Çözümleri

### iOS Platformu için "Unregistered View Type" Hatası

Eğer iOS platformunda şuna benzer bir hata alıyorsanız:

```
PlatformException (PlatformException(unregistered_view_type, A UIKitView widget is trying to create a PlatformView with an unregistered type: < com.pichillilorenzo/flutter_inappwebview >...
```

Bu sorunu çözmek için:

1. iOS Runner projenizin `AppDelegate.swift` dosyasında `GeneratedPluginRegistrant.register(with: self)` çağrısının doğru eklediğinden emin olun:

```swift
import UIKit
import Flutter
import flutter_inappwebview

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

2. Uygulamanızın main fonksiyonunda platforma özel ayarları ekleyin:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // InAppWebView için platforma özel ayarlar
  if (Platform.isIOS) {
    await InAppWebViewController.getDefaultUserAgent();
  }
  
  runApp(MyApp());
}
```

3. `Info.plist` dosyasında gerekli izinlerin eklendiğinden emin olun:

```xml
<key>io.flutter.embedded_views_preview</key>
<true/>
```
