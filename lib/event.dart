import 'package:event_bus/event_bus.dart';

class EventBusManager {
  late final EventBus eventBus;
  EventBusManager._(){
    this.eventBus = EventBus();
  }
  static final instance = EventBusManager._();
}