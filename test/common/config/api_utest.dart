import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:livria_user/common/config/api_config.dart';

void main() {
  group('apiBase - Configuración de Endpoints', () {

    test('Should return 10.0.2.2:5119 when platform is Android', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final result = apiBase();
      expect(result, 'http://10.0.2.2:5119');
    });

    test('Should return localhost:5119 when platform is iOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final result = apiBase();
      expect(result, 'http://localhost:5119');
    });

    test('Should return localhost:5119 for default platforms (e.g., Linux)', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      final result = apiBase();
      expect(result, 'http://localhost:5119');
    });

    tearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });
  });
}