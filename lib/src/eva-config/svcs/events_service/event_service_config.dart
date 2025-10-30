import 'package:eva_connector/src/eva-config/svcs/isvc_config.dart';

class EventServiceConfig extends ISvcConfig {
  String db = 'postgres://postgres:password@127.0.0.1:5432/scada';
  String table = 'events';
  String updateLvar = '';
  int currentEventLimit = 30;
  int? removeEventsAfterDays = 30;
  Map<String, Event> events = {};

  @override
  void loadFromMap(Map map) {
    db = map['db'];
    table = map['table'] ?? 'events';
    updateLvar = map['update_lvar'];
    currentEventLimit = map['current_event_limit'];
    removeEventsAfterDays = map['remove_events_after_days'];
    events.clear();
    for (var item in (map['events'] as Map).entries) {
      events[item.key] = Event.loadFromMap(item.value);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'db': db,
      'table': table,
      'update_lvar': updateLvar,
      'current_event_limit': currentEventLimit,
      'remove_events_after_days': removeEventsAfterDays,
      'events': {for (var item in events.entries) item.key: item.value.toMap()},
    };
  }
}

class Event {
  String name = 'новое событие';

  Event();

  Event.loadFromMap(Map map) : name = map['name'];

  Map toMap() => {'name': name};
}
