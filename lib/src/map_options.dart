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

  /// Kullanıcının yönünü takip etme durumu
  final bool followUserHeading;

  /// URL'de zoom parametresi var mı
  final bool hasZoom;

  /// URL'de lat/lng parametresi var mı
  final bool hasLatLng;

  /// URL'de bearing parametresi var mı
  final bool hasBearing;

  /// URL'de tilt/pitch parametresi var mı
  final bool hasTilt;

  /// URL parametre sırası (örnek: ["zoom", "lat", "lng", "bearing", "tilt"])
  final List<String>? parameterOrder;

  const MapOptions({
    required this.center,
    required this.style,
    this.zoom = 10.0,
    this.minZoom = 0.0,
    this.maxZoom = 22.0,
    this.pitch = 0.0,
    this.bearing = 0.0,
    this.followUserHeading = false,
    this.hasZoom = false,
    this.hasLatLng = false,
    this.hasBearing = false,
    this.hasTilt = false,
    this.parameterOrder,
  });

  /// URL'den harita seçenekleri oluşturur
  /// Örnek: https://inovision.tech/styles/klokantech-basic/#16.96/37.872351/32.492013/-36.9/60
  factory MapOptions.fromUrl(String url, {List<String>? parameterOrder, bool hasZoom = false, bool hasLatLng = false, bool hasBearing = false, bool hasTilt = false}) {
    // URL'den parametreleri çıkar
    try {
      // URL kısmını ve hash kısmını ayır
      final baseUrl = url.split('#')[0];
      final hashPart = url.contains('#') ? url.split('#')[1] : '';

      // Varsayılan değerler
      double zoom = 10.0;
      double lat = 0.0;
      double lng = 0.0;
      double bearing = 0.0;
      double tilt = 0.0;

      // Parametre var mı kontrolü
      bool foundZoom = false;
      bool foundLatLng = false;
      bool foundBearing = false;
      bool foundTilt = false;

      // Hash kısmı varsa ve sıralama belirtilmişse parametreleri çıkar
      if (hashPart.isNotEmpty && parameterOrder != null && parameterOrder.isNotEmpty) {
        final parts = hashPart.split('/');

        // Parametre sayısı yetersizse işlemi atla
        if (parts.length < parameterOrder.length) {
          return MapOptions(center: LatLng(lat, lng), style: baseUrl, parameterOrder: parameterOrder, hasZoom: hasZoom, hasLatLng: hasLatLng, hasBearing: hasBearing, hasTilt: hasTilt);
        }

        // Parametreleri sırayla oku
        for (int i = 0; i < parameterOrder.length; i++) {
          final param = parameterOrder[i];
          final value = parts[i];

          switch (param) {
            case 'zoom':
              if (hasZoom) {
                zoom = double.tryParse(value) ?? zoom;
                foundZoom = true;
              }
              break;
            case 'lat':
              if (hasLatLng) {
                lat = double.tryParse(value) ?? lat;
                foundLatLng = true;
              }
              break;
            case 'lng':
              if (hasLatLng) {
                lng = double.tryParse(value) ?? lng;
                foundLatLng = true;
              }
              break;
            case 'bearing':
              if (hasBearing) {
                bearing = double.tryParse(value) ?? bearing;
                foundBearing = true;
              }
              break;
            case 'tilt':
            case 'pitch':
              if (hasTilt) {
                tilt = double.tryParse(value) ?? tilt;
                foundTilt = true;
              }
              break;
          }
        }
      } else if (hashPart.isNotEmpty) {
        // Eski davranış: varsayılan sıra zoom/lat/lng/bearing/tilt
        final parts = hashPart.split('/');

        // Zoom parametresi
        if (hasZoom && parts.isNotEmpty) {
          zoom = double.tryParse(parts[0]) ?? zoom;
          foundZoom = true;
        }

        // Lat/Lng parametreleri
        if (hasLatLng && parts.length >= 3) {
          lat = double.tryParse(parts[1]) ?? lat;
          lng = double.tryParse(parts[2]) ?? lng;
          foundLatLng = true;
        }

        // Bearing parametresi
        if (hasBearing && parts.length >= 4) {
          bearing = double.tryParse(parts[3]) ?? bearing;
          foundBearing = true;
        }

        // Tilt parametresi
        if (hasTilt && parts.length >= 5) {
          tilt = double.tryParse(parts[4]) ?? tilt;
          foundTilt = true;
        }
      }

      return MapOptions(
        center: LatLng(lat, lng),
        style: baseUrl,
        zoom: zoom,
        bearing: bearing,
        pitch: tilt,
        parameterOrder: parameterOrder,
        hasZoom: foundZoom || hasZoom,
        hasLatLng: foundLatLng || hasLatLng,
        hasBearing: foundBearing || hasBearing,
        hasTilt: foundTilt || hasTilt,
      );
    } catch (e) {
      // Hata durumunda basit bir MapOptions döndür
      return MapOptions(center: const LatLng(0, 0), style: url, parameterOrder: parameterOrder, hasZoom: hasZoom, hasLatLng: hasLatLng, hasBearing: hasBearing, hasTilt: hasTilt);
    }
  }

  /// URL oluştur (harita tarzı + gerekli parametreler)
  String createUrl() {
    if (!hasZoom && !hasLatLng && !hasBearing && !hasTilt) {
      return style; // Sadece harita tarzı URL'si
    }

    // Parametreleri sıralama listesi yoksa, parametrelerin varlığına göre varsayılan sırayı oluştur
    List<String> order = parameterOrder ?? [];
    if (order.isEmpty) {
      if (hasZoom) order.add('zoom');
      if (hasLatLng) {
        order.add('lat');
        order.add('lng');
      }
      if (hasBearing) order.add('bearing');
      if (hasTilt) order.add('tilt');
    }

    // Parametreleri değerlerle eşleştir
    List<String> paramValues = [];
    for (String param in order) {
      switch (param) {
        case 'zoom':
          paramValues.add(zoom.toStringAsFixed(2));
          break;
        case 'lat':
          paramValues.add(center.latitude.toStringAsFixed(6));
          break;
        case 'lng':
          paramValues.add(center.longitude.toStringAsFixed(6));
          break;
        case 'bearing':
          paramValues.add(bearing.toStringAsFixed(2));
          break;
        case 'tilt':
        case 'pitch':
          paramValues.add(pitch.toStringAsFixed(2));
          break;
      }
    }

    // Parametreleri birleştirip URL oluştur
    return '$style#${paramValues.join('/')}';
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
