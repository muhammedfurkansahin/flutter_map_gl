import 'package:flutter/material.dart';
import 'map_options.dart';
import 'map_controller.dart';
import 'mobile_map_impl.dart';

/// Flutter Map GL Widget - Mobil platformlar için harita widget'ı
class FlutterMapGL extends StatefulWidget {
  /// Harita seçenekleri
  final MapOptions options;

  /// Harita kontrolcüsü
  final MapController? controller;

  /// Harita yüklendiğinde tetiklenen fonksiyon
  final Function()? onMapCreated;

  /// Harita tıklaması olduğunda tetiklenen fonksiyon
  final Function(LatLng)? onMapClick;

  /// Harita hareket ettiğinde tetiklenen fonksiyon
  final Function(LatLng, double)? onCameraMove;

  const FlutterMapGL({super.key, required this.options, this.controller, this.onMapCreated, this.onMapClick, this.onCameraMove});

  @override
  State<FlutterMapGL> createState() => _FlutterMapGLState();
}

class _FlutterMapGLState extends State<FlutterMapGL> {
  late final MapController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? MapController();

    // Mobil harita başlatma
    initMobileMap(_controller, widget.options);
  }

  @override
  Widget build(BuildContext context) {
    // Mobil platformlarda harita görünümü
    return buildMobileMap(context, _controller, widget.options, widget.onMapCreated, widget.onMapClick);
  }
}
