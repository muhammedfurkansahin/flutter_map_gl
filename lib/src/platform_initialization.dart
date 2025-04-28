import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// FlutterMapGL'in kullanılabilmesi için gerekli platform bağımlı
/// başlatma işlemlerini gerçekleştirir.
class FlutterMapGLPlatform {
  /// Singleton örneği
  static final FlutterMapGLPlatform _instance = FlutterMapGLPlatform._internal();

  /// Factory constructor
  factory FlutterMapGLPlatform() => _instance;

  /// Private constructor
  FlutterMapGLPlatform._internal();

  bool _isInitialized = false;

  /// Platform bağımlı başlatma işlemlerini gerçekleştirir
  /// Paketi kullanan her uygulamanın main fonksiyonunda çağrılmalıdır.
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Flutter binding'i başlat
    WidgetsFlutterBinding.ensureInitialized();

    // iOS platformunda InAppWebView için gerekli ayarlar
    if (defaultTargetPlatform == TargetPlatform.iOS || Platform.isIOS) {
      try {
        await InAppWebViewController.getDefaultUserAgent();
      } catch (e) {
        debugPrint('FlutterMapGL: InAppWebView başlatma hatası: $e');
      }
    }

    _isInitialized = true;
  }
}
