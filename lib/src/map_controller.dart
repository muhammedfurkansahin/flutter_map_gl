import 'dart:async';
import 'package:flutter/foundation.dart';
import 'map_options.dart';

/// Harita kontrolcüsü
class MapController extends ChangeNotifier {
  /// Harita üzerinde yapılacak işlemler için controller
  final Completer<bool> _readyCompleter = Completer<bool>();

  /// Haritanın mevcut konumu
  LatLng? position;

  /// Haritanın mevcut zoom seviyesi
  double? zoom;

  /// Haritanın mevcut eğimi (tilt)
  double? tilt;

  /// Haritanın mevcut yönü (bearing)
  double? bearing;

  /// Kullanıcının yönünü takip etme durumu
  bool followUserHeading = false;

  /// Haritanın hazır olup olmadığı
  Future<bool> get ready => _readyCompleter.future;

  /// Haritanın hazır olduğunu işaretler
  void markAsReady() {
    if (!_readyCompleter.isCompleted) {
      _readyCompleter.complete(true);
    }
  }

  /// Haritayı belirtilen konuma taşır
  Future<void> moveCamera(LatLng position, {double? zoom, double? tilt, double? bearing}) async {
    if (kDebugMode) {
      print('moveCamera: $position, zoom: $zoom, tilt: $tilt, bearing: $bearing');
    }
    this.position = position;
    if (zoom != null) {
      this.zoom = zoom;
    }
    if (tilt != null) {
      this.tilt = tilt;
    }
    if (bearing != null) {
      this.bearing = bearing;
    }
    notifyListeners();
  }

  /// Haritanın yakınlaştırma seviyesini değiştirir
  Future<void> setZoom(double zoom) async {
    if (kDebugMode) {
      print('setZoom: $zoom');
    }
    this.zoom = zoom;
    notifyListeners();
  }

  /// Harita stilini değiştirir
  Future<void> setStyle(String styleUrl) async {
    if (kDebugMode) {
      print('setStyle: $styleUrl');
    }
    // Stil değişimini bildir
    notifyListeners();
  }

  /// Harita eğimini değiştirir
  Future<void> setTilt(double tilt) async {
    if (kDebugMode) {
      print('setTilt: $tilt');
    }
    this.tilt = tilt;
    notifyListeners();
  }

  /// Harita yönünü değiştirir
  Future<void> setBearing(double bearing) async {
    if (kDebugMode) {
      print('setBearing: $bearing');
    }
    this.bearing = bearing;
    notifyListeners();
  }

  /// Kullanıcının yönünü takip etme özelliğini aç/kapat
  Future<void> setFollowUserHeading(bool follow) async {
    if (kDebugMode) {
      print('setFollowUserHeading: $follow');
    }
    followUserHeading = follow;
    notifyListeners();
  }
}
