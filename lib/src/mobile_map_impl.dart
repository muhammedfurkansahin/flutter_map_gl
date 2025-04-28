import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'map_options.dart';
import 'map_controller.dart';

/// Mobil haritayı başlatan fonksiyon
void initMobileMap(MapController controller, MapOptions options) {
  // Mobil harita kontrollerini başlat
  controller.markAsReady();

  // Başlangıç değerlerini ayarla
  controller.position = options.center;
  controller.zoom = options.zoom;
}

/// Platformların hazır olduğundan emin ol
Future<void> ensurePlatformViewsInitialized() async {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    // iOS platformunda WebView'ın düzgün çalışması için gerekli
    await InAppWebViewController.getDefaultUserAgent();
  }
}

/// Mobil harita widget'ını oluşturan fonksiyon - InAppWebView tabanlı
Widget buildMobileMap(BuildContext context, MapController controller, MapOptions options, Function()? onMapCreated, Function(LatLng)? onMapClick) {
  // iOS için platform view'ı hazırla
  WidgetsFlutterBinding.ensureInitialized();
  ensurePlatformViewsInitialized();

  // URL ile harita koordinatlarını ayarla
  final String mapUrl = options.style;

  // Haritada görüntülemek için merkez, zoom, bearing ve tilt değerlerini belirle
  final double latitude = controller.position?.latitude ?? options.center.latitude;
  final double longitude = controller.position?.longitude ?? options.center.longitude;
  final double zoom = controller.zoom ?? options.zoom;
  final double bearing = options.bearing;
  final double tilt = options.pitch;

  // URL oluştur
  final String fullMapUrl = '$mapUrl#${zoom.toStringAsFixed(2)}/$latitude/$longitude/$bearing/$tilt';

  return Stack(
    children: [
      // InAppWebView ile haritayı göster
      InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(fullMapUrl)),
        initialSettings: InAppWebViewSettings(useShouldOverrideUrlLoading: true, mediaPlaybackRequiresUserGesture: false, javaScriptEnabled: true, javaScriptCanOpenWindowsAutomatically: true),
        onWebViewCreated: (InAppWebViewController webViewController) {
          // Harita kontrollerini başlat
          controller.markAsReady();
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) {
          if (onMapCreated != null) {
            onMapCreated();
          }
        },
        onConsoleMessage: (InAppWebViewController controller, ConsoleMessage consoleMessage) {
          debugPrint("Console message: ${consoleMessage.message}");
        },
      ),

      // Kontrol butonları
      Positioned(
        bottom: 16.0,
        right: 16.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Zoom in
            FloatingActionButton(
              heroTag: "map_gl_zoom_in_${DateTime.now().microsecondsSinceEpoch}",
              mini: true,
              child: const Icon(Icons.add),
              onPressed: () {
                final newZoom = (controller.zoom ?? options.zoom) + 1;
                controller.setZoom(newZoom);
              },
            ),
            const SizedBox(height: 8.0),
            // Zoom out
            FloatingActionButton(
              heroTag: "map_gl_zoom_out_${DateTime.now().microsecondsSinceEpoch}",
              mini: true,
              child: const Icon(Icons.remove),
              onPressed: () {
                final newZoom = (controller.zoom ?? options.zoom) - 1;
                controller.setZoom(newZoom);
              },
            ),
          ],
        ),
      ),
    ],
  );
}
