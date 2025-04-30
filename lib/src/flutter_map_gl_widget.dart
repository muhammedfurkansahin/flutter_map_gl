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

  /// Harita yönü değiştiğinde tetiklenen fonksiyon
  final Function(double)? onBearingChange;

  /// URL parametrelerinin varlığını ve sırasını belirten, özelleştirilmiş bir harita oluşturur
  FlutterMapGL.withCustomParameters({
    super.key,
    required String style,
    required LatLng center,
    double zoom = 10.0,
    double bearing = 0.0,
    double pitch = 0.0,
    bool followUserHeading = false,
    List<String>? parameterOrder,
    bool hasZoom = false,
    bool hasLatLng = false,
    bool hasBearing = false,
    bool hasTilt = false,
    this.controller,
    this.onMapCreated,
    this.onMapClick,
    this.onCameraMove,
    this.onBearingChange,
  }) : options = MapOptions(
         center: center,
         style: style,
         zoom: zoom,
         bearing: bearing,
         pitch: pitch,
         followUserHeading: followUserHeading,
         parameterOrder: parameterOrder,
         hasZoom: hasZoom,
         hasLatLng: hasLatLng,
         hasBearing: hasBearing,
         hasTilt: hasTilt,
       );

  const FlutterMapGL({
    super.key,
    required this.options,
    this.controller,
    this.onMapCreated,
    this.onMapClick,
    this.onCameraMove,
    this.onBearingChange,
  });

  @override
  State<FlutterMapGL> createState() => _FlutterMapGLState();
}

class _FlutterMapGLState extends State<FlutterMapGL> {
  late final MapController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? MapController();

    // Controller değişikliklerini dinle
    _controller.addListener(_onControllerChanged);

    // Mobil harita başlatma
    initMobileMap(_controller, widget.options);
  }

  @override
  void dispose() {
    // Listener'ı kaldır
    _controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {
      // Harita durumu değiştiğinde widget'ı yeniden çiz
      if (widget.onCameraMove != null &&
          _controller.position != null &&
          _controller.zoom != null) {
        widget.onCameraMove!(_controller.position!, _controller.zoom!);
      }

      // Bearing değişimini bildir
      if (widget.onBearingChange != null && _controller.bearing != null) {
        widget.onBearingChange!(_controller.bearing!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mobil platformlarda harita görünümü
    return buildMobileMap(
      context,
      _controller,
      widget.options,
      widget.onMapCreated,
      widget.onMapClick,
    );
  }
}
