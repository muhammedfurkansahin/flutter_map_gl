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

  /// Haritanın hazır olup olmadığı
  Future<bool> get ready => _readyCompleter.future;

  /// Haritanın hazır olduğunu işaretler
  void markAsReady() {
    if (!_readyCompleter.isCompleted) {
      _readyCompleter.complete(true);
    }
  }

  /// Haritayı belirtilen konuma taşır
  Future<void> moveCamera(LatLng position, {double? zoom}) async {
    if (kDebugMode) {
      print('moveCamera: $position, zoom: $zoom');
    }
    this.position = position;
    if (zoom != null) {
      this.zoom = zoom;
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
}
