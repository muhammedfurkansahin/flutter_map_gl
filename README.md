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
- 3D harita desteği (zoom, bearing, pitch/tilt)
- Harita kontrolcüsü ile harita üzerinde işlemler yapma
- Harita olaylarını dinleme (tıklama, hareket, vb.)
- URL tabanlı harita yapılandırması

## Başlangıç

Paketi projenize eklemek için `pubspec.yaml` dosyanıza şu satırları ekleyin:

```yaml
dependencies:
  flutter_map_gl: ^0.1.4
  webview_flutter: ^4.11.0
```

Daha sonra bağımlılıkları yükleyin:

```bash
flutter pub get
```

## Kullanım

Temel bir harita gösterimi için:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_map_gl/flutter_map_gl.dart';

class MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterMapGL(
      options: MapOptions(
        center: LatLng(41.0082, 28.9784), // İstanbul
        style: 'https://your-map-server.com/map-style/',
        zoom: 11.0,
        bearing: 0.0,    // Harita rotasyonu (0-360 derece)
        pitch: 45.0,     // Harita eğimi (0-60 derece)
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
    bearing: 0.0,
    pitch: 45.0,
  ),
  controller: controller,
  onMapCreated: () {
    print('Harita oluşturuldu!');
  },
  onMapClick: (latLng) {
    print('Haritada tıklandı: $latLng');
  },
  onCameraMove: (position, zoom) {
    print('Kamera hareketi: $position, Zoom: $zoom');
  },
)

// Haritayı hareket ettirme
controller.moveCamera(LatLng(41.01, 28.98), zoom: 15.0);

// Yakınlaştırma seviyesini değiştirme
controller.setZoom(12.0);

// Harita stilini değiştirme
controller.setStyle('https://your-map-server.com/different-style/');
```

## WebView ve 3D Harita Entegrasyonu

Bu paket, sunucunuzdaki 3D haritaları WebView içinde göstermek için tasarlanmıştır. Haritanızın JavaScript API'si aşağıdaki özellikleri desteklemelidir:

```javascript
// Harita yükleme sonrası event listener'ları ekleyin
map.on('click', function(e) {
  const lat = e.lngLat.lat;
  const lng = e.lngLat.lng;
  // Flutter'a tıklama bilgisini gönder
  MapChannel.postMessage('click:' + lat + ',' + lng);
});

// Harita hareketi sonrası bildirim
map.on('moveend', function() {
  const center = map.getCenter();
  const zoom = map.getZoom();
  // Flutter'a kamera hareketi bilgisini gönder
  MapChannel.postMessage('move:' + center.lat + ',' + center.lng + ',' + zoom);
});

// Zoom değiştirme metodu
map.setZoom(14.5);

// Bearing (pusula) değiştirme
map.setBearing(45);

// Pitch (eğim) değiştirme
map.setPitch(60);
```

## URL Tabanlı Harita Yapılandırması

Flutter Map GL, URL'den harita parametrelerini çıkarabilir. Bu, harita yapılandırmanızı tek bir URL ile yönetmenizi sağlar:

```dart
// URL formatı: temelUrl#zoom/lat/lng/bearing/tilt
final String mapUrl = "https://your-map-server.com/styles/main-style/#16.96/37.872351/32.492013/-36.9/60";

// URL'den harita seçeneklerini oluştur
final mapOptions = MapOptions.fromUrl(mapUrl);

// Haritayı göster
FlutterMapGL(
  options: mapOptions,
  controller: controller,
)
```

## Android Manifest İzinleri

Android uygulamanızın AndroidManifest.xml dosyasına aşağıdaki izinleri eklediğinizden emin olun:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

Konum hizmetleri kullanacaksanız, bu izinleri de ekleyin:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

## iOS Info.plist Tanımları

iOS uygulamanızın Info.plist dosyasına aşağıdaki tanımları eklediğinizden emin olun:

```xml
<key>io.flutter.embedded_views_preview</key>
<true/>

<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

Konum hizmetleri kullanacaksanız:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Harita özelliklerini kullanabilmek için konum izni gerekiyor</string>
```

## Platform Desteği

| Platform | Durum |
| -------- | ----- |
| Android | ✅ Destekleniyor |
| iOS | ✅ Destekleniyor |

## Performans İpuçları

3D haritalar yüksek performans gerektirdiğinden, aşağıdaki ipuçlarını dikkate alın:

1. WebView yüklenirken bir yükleme göstergesi ekleyin
2. Cihaz performansına göre harita kalitesini ayarlayın
3. Büyük haritaları lazy loading ile yükleyin
4. Haritanın görünür olmadığı durumlarda WebView'i dispose edin
5. Android ve iOS için ayrı WebView yapılandırmaları kullanın

## Örnek Kullanım Senaryoları

- Özel 3D şehir modelleri görüntüleme
- Oyun benzeri haritalandırma sistemleri
- Mimari ve arazi görselleştirme
- Sanal tur ve gezinti uygulamaları
- Özelleştirilmiş tematik haritalar

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
