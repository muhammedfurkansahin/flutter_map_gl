import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'map_options.dart';
import 'map_controller.dart';

/// Mobil haritayı başlatan fonksiyon
void initMobileMap(MapController controller, MapOptions options) {
  // Mobil harita kontrollerini başlat
  controller.markAsReady();

  // Başlangıç değerlerini ayarla
  controller.position = options.center;
  controller.zoom = options.zoom;

  // WebView başlatma - webview_flutter 4+ sürümünde artık bu adıma gerek yok
  // PlatformWebViewControllerCreationParams varsayılan olarak kullanılır
}

/// Mobil harita widget'ını oluşturan fonksiyon - WebView tabanlı
Widget buildMobileMap(BuildContext context, MapController mapController, MapOptions options, Function()? onMapCreated, Function(LatLng)? onMapClick) {
  // URL ile harita koordinatlarını ayarla
  final String mapUrl = options.style;

  // Haritada görüntülemek için merkez, zoom, bearing ve tilt değerlerini belirle
  final double latitude = mapController.position?.latitude ?? options.center.latitude;
  final double longitude = mapController.position?.longitude ?? options.center.longitude;
  final double zoom = mapController.zoom ?? options.zoom;
  final double bearing = options.bearing;
  final double tilt = options.pitch;

  // Harita URL'sini oluştur
  final String formattedMapUrl = '$mapUrl#${zoom.toStringAsFixed(2)}/$latitude/$longitude/$bearing/$tilt';

  // Platforma özel WebViewController parametreleri
  final PlatformWebViewControllerCreationParams params;
  if (WebViewPlatform.instance is WebKitWebViewPlatform) {
    params = WebKitWebViewControllerCreationParams(allowsInlineMediaPlayback: true, mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{});
  } else {
    params = const PlatformWebViewControllerCreationParams();
  }

  final WebViewController webViewController =
      WebViewController.fromPlatformCreationParams(params)
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              // JavaScript kodlarınız
            },
          ),
        )
        ..addJavaScriptChannel(
          'MapChannel',
          onMessageReceived: (JavaScriptMessage message) {
            // Mesaj işleme
          },
        )
        ..loadRequest(Uri.parse(formattedMapUrl));

  // Android için ek konfigürasyon
  if (webViewController.platform is AndroidWebViewController) {
    (webViewController.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
  }

  return WebViewWidget(controller: webViewController);
}
