import 'package:edge_panel/providers/sensor_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats readings and clears them when the server fails', () async {
    Map<String, dynamic>? payload = {
      'status': 'ok',
      'reading': {
        'temperature_c': 26.14,
        'humidity_rh_pct': 62.12,
        'eco2_ppm': 550,
        'validity': 'normal',
      },
    };
    final provider = SensorProvider(fetchData: () async => payload);
    addTearDown(provider.dispose);
    await Future<void>.delayed(Duration.zero);
    expect(provider.temperature, '26.1');
    expect(provider.humidity, '62.1');
    expect(provider.eco2, '550');

    payload!['reading']['validity'] = 'warmup';
    await provider.refresh();
    expect(provider.temperature, '26.1');
    expect(provider.eco2, '--');

    payload = null;
    await provider.refresh();
    expect(provider.temperature, '--');
    expect(provider.humidity, '--');
    expect(provider.eco2, '--');
  });

  test('ignores a response that arrives after disposal', () async {
    final provider = SensorProvider(fetchData: () async => {'status': 'error'});
    provider.dispose();
    await Future<void>.delayed(Duration.zero);
    expect(provider.temperature, '--');
  });
}
