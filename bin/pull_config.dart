import 'package:busrt_client/busrt_client.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

void main(List<String> args) async {
  final bus = Bus('losev.test');
  await bus.connect('192.168.1.47:10001');
  final rpc = Rpc(bus);

  final res = await rpc.call(
    'softkip.events.alarms',
    'event.acknowledge',
    params: serialize({
      'ids': [180, 181, 182, 183, 184, 185, 186, 187],
    }),
  );

  final p = await res.waitCompleted();

  print(deserialize(p!.payload));
  // (deserialize(p!.payload)['events'] as List).forEach(print);

  bus.disconnect();
}
