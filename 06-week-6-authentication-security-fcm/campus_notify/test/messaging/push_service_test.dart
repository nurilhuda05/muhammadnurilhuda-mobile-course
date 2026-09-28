import 'package:campus_notify/messaging/push_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('routeFromMessage', () {
    test('mengembalikan route dari data jika key "route" ada', () {
      final data = {'route': '/pengumuman/42'};
      expect(routeFromMessage(data), '/pengumuman/42');
    });

    test('mengembalikan "/" jika key "route" tidak ada', () {
      expect(routeFromMessage({}), '/');
    });

    test('mengembalikan "/" jika nilai "route" null', () {
      final data = <String, dynamic>{'route': null};
      expect(routeFromMessage(data), '/');
    });

    test('mengembalikan "/" jika nilai "route" bukan String', () {
      final data = <String, dynamic>{'route': 123};
      expect(routeFromMessage(data), '/');
    });
  });
}
