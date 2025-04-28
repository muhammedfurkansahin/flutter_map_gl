/// Harita için gerekli yapılandırma seçenekleri
class MapOptions {
  /// Haritanın başlangıç merkezi (enlem, boylam)
  final LatLng center;

  /// Haritanın yakınlaştırma seviyesi
  final double zoom;

  /// Harita stili URL'si
  final String style;

  /// Minimum yakınlaştırma seviyesi
  final double minZoom;

  /// Maksimum yakınlaştırma seviyesi
  final double maxZoom;

  /// Harita eğimi (tilt) - 0-60 derece arası
  final double pitch;

  /// Harita rotasyonu (derece) - -180 ile 180 arası
  final double bearing;

  const MapOptions({required this.center, required this.style, this.zoom = 10.0, this.minZoom = 0.0, this.maxZoom = 22.0, this.pitch = 0.0, this.bearing = 0.0});

  /// URL'den harita seçenekleri oluşturur
  /// Örnek: https://inovision.tech/styles/klokantech-basic/#16.96/37.872351/32.492013/-36.9/60
  factory MapOptions.fromUrl(String url) {
    // URL'den parametreleri çıkar
    try {
      // URL kısmını ve hash kısmını ayır
      final baseUrl = url.split('#')[0];
      final hashPart = url.contains('#') ? url.split('#')[1] : '';

      // Hash kısmından parametreleri çıkar (zoom/lat/lng/bearing/tilt)
      final parts = hashPart.split('/');

      // Varsayılan değerler
      double zoom = 10.0;
      double lat = 0.0;
      double lng = 0.0;
      double bearing = 0.0;
      double tilt = 0.0;

      // Parametreleri kontrol et ve doldur
      if (parts.length >= 3) {
        zoom = double.tryParse(parts[0]) ?? 10.0;
        lat = double.tryParse(parts[1]) ?? 0.0;
        lng = double.tryParse(parts[2]) ?? 0.0;
      }

      if (parts.length >= 4) {
        bearing = double.tryParse(parts[3]) ?? 0.0;
      }

      if (parts.length >= 5) {
        tilt = double.tryParse(parts[4]) ?? 0.0;
      }

      return MapOptions(center: LatLng(lat, lng), style: baseUrl, zoom: zoom, bearing: bearing, pitch: tilt);
    } catch (e) {
      // Hata durumunda basit bir MapOptions döndür
      return MapOptions(center: const LatLng(0, 0), style: url);
    }
  }
}

/// Enlem ve boylam bilgisini tutan sınıf
class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);

  @override
  String toString() => '[$latitude, $longitude]';
}
