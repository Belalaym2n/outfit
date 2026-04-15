
// lib/core/utils/map_link_parser.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLinkParser {
   static LatLng? parseMapLink(String url) {
    try {
      // ========================================
      // 1️⃣ geo: scheme
      // ========================================
      // Examples:
      // geo:33.312805,44.361488
      // geo:33.312805,44.361488?z=17
      // geo:0,0?q=33.312805,44.361488
      if (url.startsWith('geo:')) {
        return _parseGeoScheme(url);
      }

      // ========================================
      // 2️⃣ HTTPS Google Maps URLs
      // ========================================
      if (url.contains('google.com/maps') ||
          url.contains('maps.google.com') ||
          url.contains('goo.gl/maps')) {
        return _parseHttpsMapUrl(url);
      }

      // ========================================
      // 3️⃣ google.navigation scheme (نادر)
      // ========================================
      // google.navigation:q=33.312805,44.361488
      if (url.startsWith('google.navigation:')) {
        return _parseNavigationScheme(url);
      }

      return null;
    } catch (e) {
      print('❌ MapLinkParser Error: $e');
      return null;
    }
  }

  // ==========================================
  // Parse geo: scheme
  // ==========================================
  static LatLng? _parseGeoScheme(String url) {
    try {
      // Remove "geo:" prefix
      String coords = url.substring(4);

      // Remove query parameters if exist (after ?)
      if (coords.contains('?')) {
        // geo:0,0?q=33.312805,44.361488
        final parts = coords.split('?');
        coords = parts[0];

        // Check if there's a 'q' parameter with actual coordinates
        if (parts.length > 1) {
          final query = parts[1];
          final qMatch = RegExp(r'q=([0-9.-]+),([0-9.-]+)').firstMatch(query);
          if (qMatch != null) {
            final lat = double.tryParse(qMatch.group(1)!);
            final lng = double.tryParse(qMatch.group(2)!);
            if (lat != null && lng != null) {
              return LatLng(lat, lng);
            }
          }
        }
      }

      // Parse direct coordinates: geo:33.312805,44.361488
      final latLng = coords.split(',');
      if (latLng.length >= 2) {
        final lat = double.tryParse(latLng[0].trim());
        final lng = double.tryParse(latLng[1].trim());

        if (lat != null && lng != null) {
          // Validate coordinates range
          if (_isValidCoordinate(lat, lng)) {
            return LatLng(lat, lng);
          }
        }
      }

      return null;
    } catch (e) {
      print('❌ _parseGeoScheme Error: $e');
      return null;
    }
  }

  // ==========================================
  // Parse HTTPS Google Maps URLs
  // ==========================================
  static LatLng? _parseHttpsMapUrl(String url) {
    try {
      // ==========================================
      // Pattern 1: ?q=lat,lng
      // https://maps.google.com/?q=33.312805,44.361488
      // ==========================================
      RegExp qPattern = RegExp(r'[?&]q=([0-9.-]+),([0-9.-]+)');
      var match = qPattern.firstMatch(url);
      if (match != null) {
        final lat = double.tryParse(match.group(1)!);
        final lng = double.tryParse(match.group(2)!);
        if (lat != null && lng != null && _isValidCoordinate(lat, lng)) {
          return LatLng(lat, lng);
        }
      }

      // ==========================================
      // Pattern 2: /@lat,lng,zoom
      // https://www.google.com/maps/place/Baghdad/@33.312805,44.361488,17z
      // ==========================================
      RegExp atPattern = RegExp(r'/@([0-9.-]+),([0-9.-]+),([0-9.]+)z');
      match = atPattern.firstMatch(url);
      if (match != null) {
        final lat = double.tryParse(match.group(1)!);
        final lng = double.tryParse(match.group(2)!);
        if (lat != null && lng != null && _isValidCoordinate(lat, lng)) {
          return LatLng(lat, lng);
        }
      }

      // ==========================================
      // Pattern 3: /place/Name/@lat,lng
      // ==========================================
      RegExp placePattern = RegExp(r'/place/[^/]+/@([0-9.-]+),([0-9.-]+)');
      match = placePattern.firstMatch(url);
      if (match != null) {
        final lat = double.tryParse(match.group(1)!);
        final lng = double.tryParse(match.group(2)!);
        if (lat != null && lng != null && _isValidCoordinate(lat, lng)) {
          return LatLng(lat, lng);
        }
      }

      // ==========================================
      // Pattern 4: ll=lat,lng (link parameter)
      // ==========================================
      RegExp llPattern = RegExp(r'[?&]ll=([0-9.-]+),([0-9.-]+)');
      match = llPattern.firstMatch(url);
      if (match != null) {
        final lat = double.tryParse(match.group(1)!);
        final lng = double.tryParse(match.group(2)!);
        if (lat != null && lng != null && _isValidCoordinate(lat, lng)) {
          return LatLng(lat, lng);
        }
      }

      // ==========================================
      // Pattern 5: /dir//lat,lng
      // للروابط التي تحتوي على directions
      // ==========================================
      RegExp dirPattern = RegExp(r'/dir/[^/]*/([0-9.-]+),([0-9.-]+)');
      match = dirPattern.firstMatch(url);
      if (match != null) {
        final lat = double.tryParse(match.group(1)!);
        final lng = double.tryParse(match.group(2)!);
        if (lat != null && lng != null && _isValidCoordinate(lat, lng)) {
          return LatLng(lat, lng);
        }
      }

      return null;
    } catch (e) {
      print('❌ _parseHttpsMapUrl Error: $e');
      return null;
    }
  }

  // ==========================================
  // Parse google.navigation scheme
  // ==========================================
  static LatLng? _parseNavigationScheme(String url) {
    try {
      // google.navigation:q=33.312805,44.361488
      RegExp pattern = RegExp(r'q=([0-9.-]+),([0-9.-]+)');
      var match = pattern.firstMatch(url);

      if (match != null) {
        final lat = double.tryParse(match.group(1)!);
        final lng = double.tryParse(match.group(2)!);
        if (lat != null && lng != null && _isValidCoordinate(lat, lng)) {
          return LatLng(lat, lng);
        }
      }

      return null;
    } catch (e) {
      print('❌ _parseNavigationScheme Error: $e');
      return null;
    }
  }

  // ==========================================
  // Validate coordinates range
  // ==========================================
  static bool _isValidCoordinate(double lat, double lng) {
    return lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180;
  }

  // ==========================================
  // Get readable address from coordinates
  // يمكن استخدامها لعرض رسالة للمستخدم
  // ==========================================
  static String formatCoordinates(LatLng coords) {
    return '${coords.latitude.toStringAsFixed(6)}, ${coords.longitude.toStringAsFixed(6)}';
  }
}