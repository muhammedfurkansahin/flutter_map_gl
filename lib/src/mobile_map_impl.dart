import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'map_options.dart';
import 'map_controller.dart';
import 'dart:convert';

/// Mobil haritayı başlatan fonksiyon
void initMobileMap(MapController controller, MapOptions options) {
  // Mobil harita kontrollerini başlat
  controller.markAsReady();

  // Başlangıç değerlerini ayarla
  controller.position = options.center;
  controller.zoom = options.zoom;
  controller.tilt = options.pitch;
  controller.bearing = options.bearing;
  controller.followUserHeading = options.followUserHeading;

  // WebView başlatma - webview_flutter 4+ sürümünde artık bu adıma gerek yok
  // PlatformWebViewControllerCreationParams varsayılan olarak kullanılır
}

/// Mobil harita widget'ını oluşturan fonksiyon - WebView tabanlı
Widget buildMobileMap(
  BuildContext context,
  MapController mapController,
  MapOptions options,
  Function()? onMapCreated,
  Function(LatLng)? onMapClick,
) {
  // Güncel harita değerlerini al
  final LatLng position = mapController.position ?? options.center;
  final double zoom = mapController.zoom ?? options.zoom;
  final double bearing = mapController.bearing ?? options.bearing;
  final double tilt = mapController.tilt ?? options.pitch;
  final bool followUserHeading = mapController.followUserHeading;

  // Dinamik URL oluşturmak için MapOptions'ı güncelle
  final updatedOptions = MapOptions(
    center: position,
    style: options.style,
    zoom: zoom,
    bearing: bearing,
    pitch: tilt,
    followUserHeading: followUserHeading,
    hasZoom: options.hasZoom,
    hasLatLng: options.hasLatLng,
    hasBearing: options.hasBearing,
    hasTilt: options.hasTilt,
    parameterOrder: options.parameterOrder,
  );

  // Harita URL'sini oluştur
  final String formattedMapUrl = updatedOptions.createUrl();

  if (kDebugMode) {
    print('Harita URL: $formattedMapUrl');
    print(
      'Parametre bilgileri: zoom=${updatedOptions.hasZoom}, '
      'latLng=${updatedOptions.hasLatLng}, '
      'bearing=${updatedOptions.hasBearing}, '
      'tilt=${updatedOptions.hasTilt}',
    );
    if (updatedOptions.parameterOrder != null) {
      print('Parametre sırası: ${updatedOptions.parameterOrder!.join("/")}');
    }
  }

  // JavaScript konfigürasyon kodu
  final String jsConfig = '''
    var mapConfig = {
      followUserHeading: $followUserHeading,
      center: [${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}],
      zoom: ${zoom.toStringAsFixed(2)},
      bearing: ${bearing.toStringAsFixed(2)},
      tilt: ${tilt.toStringAsFixed(2)},
      hasZoom: ${options.hasZoom},
      hasLatLng: ${options.hasLatLng},
      hasBearing: ${options.hasBearing},
      hasTilt: ${options.hasTilt},
      parameterOrder: ${options.parameterOrder != null ? json.encode(options.parameterOrder) : 'null'}
    };
    
    // Kullanıcı hareket yönü takibi için geolocation API'sini etkinleştirme
    if (mapConfig.followUserHeading) {
      initHeadingTracking();
    }
    
    function initHeadingTracking() {
      if (navigator.geolocation) {
        navigator.geolocation.watchPosition(
          function(position) {
            if (position.coords.heading != null) {
              // Pusula yönünü haritaya uygula
              updateMapBearing(position.coords.heading);
              // Flutter'a bilgi gönder
              MapChannel.postMessage(JSON.stringify({
                'type': 'heading',
                'heading': position.coords.heading
              }));
            }
          },
          function(error) {
            MapChannel.postMessage(JSON.stringify({
              'type': 'error',
              'message': 'Geolocation error: ' + error.message
            }));
          },
          { 
            enableHighAccuracy: true, 
            maximumAge: 0, 
            timeout: 5000 
          }
        );
      }
    }
    
    function updateMapBearing(heading) {
      // Harita kütüphanesine göre bearing güncelleme
      // Bu kısım kullanılan harita kütüphanesine göre değiştirilmeli
      // Örnek: map.setBearing(heading);
    }
    
    // Haritayı güncellemek için URL parametrelerini oluştur
    function createMapUrl(config) {
      if (!config.hasZoom && !config.hasLatLng && !config.hasBearing && !config.hasTilt) {
        return window.location.href.split('#')[0]; // Sadece base URL
      }
      
      let baseUrl = window.location.href.split('#')[0];
      let params = [];
      
      if (config.parameterOrder && Array.isArray(config.parameterOrder)) {
        // Belirtilen sırayla parametreleri ekle
        config.parameterOrder.forEach(param => {
          switch(param) {
            case 'zoom':
              if (config.hasZoom) params.push(config.zoom.toFixed(2));
              break;
            case 'lat':
              if (config.hasLatLng) params.push(config.center[0].toFixed(6));
              break;
            case 'lng':
              if (config.hasLatLng) params.push(config.center[1].toFixed(6));
              break;
            case 'bearing':
              if (config.hasBearing) params.push(config.bearing.toFixed(2));
              break;
            case 'tilt':
            case 'pitch':
              if (config.hasTilt) params.push(config.tilt.toFixed(2));
              break;
          }
        });
      } else {
        // Varsayılan sırayla parametreleri ekle
        if (config.hasZoom) params.push(config.zoom.toFixed(2));
        if (config.hasLatLng) {
          params.push(config.center[0].toFixed(6));
          params.push(config.center[1].toFixed(6));
        }
        if (config.hasBearing) params.push(config.bearing.toFixed(2));
        if (config.hasTilt) params.push(config.tilt.toFixed(2));
      }
      
      return params.length > 0 ? baseUrl + '#' + params.join('/') : baseUrl;
    }
  ''';

  // Platforma özel WebViewController parametreleri
  final PlatformWebViewControllerCreationParams params;
  if (WebViewPlatform.instance is WebKitWebViewPlatform) {
    params = WebKitWebViewControllerCreationParams(
      allowsInlineMediaPlayback: true,
      mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
    );
  } else {
    params = const PlatformWebViewControllerCreationParams();
  }

  // WebViewController oluştur
  late WebViewController controller;

  controller =
      WebViewController.fromPlatformCreationParams(params)
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              // JavaScript kodlarını sayfaya yükleme
              controller.runJavaScript(jsConfig);

              if (onMapCreated != null) {
                onMapCreated();
              }
            },
          ),
        )
        ..addJavaScriptChannel(
          'MapChannel',
          onMessageReceived: (JavaScriptMessage message) {
            try {
              final Map<String, dynamic> data = jsonDecode(message.message);

              if (data['type'] == 'click' && onMapClick != null) {
                final double lat = data['latitude'];
                final double lng = data['longitude'];
                onMapClick(LatLng(lat, lng));
              } else if (data['type'] == 'heading') {
                // Eğer followUserHeading aktifse ve kullanıcı yönü değiştiyse
                if (mapController.followUserHeading) {
                  mapController.bearing = data['heading'];
                  mapController.notifyListeners();
                }
              }
            } catch (e) {
              debugPrint('MapChannel JSON parse error: $e');
            }
          },
        )
        ..loadRequest(Uri.parse(formattedMapUrl));

  // Android için ek konfigürasyon
  if (controller.platform is AndroidWebViewController) {
    (controller.platform as AndroidWebViewController)
        .setMediaPlaybackRequiresUserGesture(false);
  }

  return WebViewWidget(controller: controller);
}
