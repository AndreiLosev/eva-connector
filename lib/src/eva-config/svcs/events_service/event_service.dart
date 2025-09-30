import 'package:eva_connector/src/eva-config/svcs/base_svc.dart';
import 'package:eva_connector/src/eva-config/svcs/events_service/event_service_config.dart';

class EventService extends BaseSvc<EventServiceConfig> {
  static const svcCommand = "svc/softkip-event-service";
  EventService(String id)
    : super(id, EventService.svcCommand, EventServiceConfig());
}
