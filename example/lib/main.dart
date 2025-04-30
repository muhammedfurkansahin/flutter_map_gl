import 'package:flutter/material.dart';
import 'package:flutter_map_gl/flutter_map_gl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map GL Örneği',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _controller = MapController();

  // Klokantech temel harita URL'i ve parametreleri
  final String _mapUrl = "url";
  late MapOptions _mapOptions;

  @override
  void initState() {
    super.initState();
    // URL'den harita seçeneklerini oluştur
    _mapOptions = MapOptions.fromUrl(_mapUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Map GL Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                // Harita seçeneklerini yeniden yükle
                _mapOptions = MapOptions.fromUrl(_mapUrl);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMapGL(
              options: _mapOptions,
              controller: _controller,
              onMapCreated: () {
                debugPrint('Harita oluşturuldu!');
              },
              onMapClick: (latLng) {
                debugPrint('Haritada tıklandı: $latLng');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Konum: ${_mapOptions.center.latitude.toStringAsFixed(6)}, ${_mapOptions.center.longitude.toStringAsFixed(6)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Zoom: ${_mapOptions.zoom.toStringAsFixed(2)} | Bearing: ${_mapOptions.bearing.toStringAsFixed(1)}° | Tilt: ${_mapOptions.pitch.toStringAsFixed(1)}°',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'zoom_in',
            onPressed: () {
              _controller.setZoom(_mapOptions.zoom + 1);
              setState(() {});
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'zoom_out',
            onPressed: () {
              _controller.setZoom(_mapOptions.zoom - 1);
              setState(() {});
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
