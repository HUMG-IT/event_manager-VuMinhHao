import 'package:localstore/localstore.dart';

import 'event_model.dart';

class EventService {
  final db = Localstore.getInstance(useSupportDir: true);
  final path = 'events';
  Future<List<EventModel>> getAllEvents() async {
    final eventsMap = await db.collection(path).get();
    if (eventsMap != null) {
      return eventsMap.entries.map((entry) {
        final eventData = entry.value as Map<String, dynamic>;
        if (!eventData.containsKey('id')) {
          eventData['id'] = entry.key.split('/').last;
        }
        return EventModel.fromMap(eventData);
      }).toList();
    }
    return [];
  }

  Future<void> saveEvent(EventModel items) async {
    items.id ??= db.collection(path).doc().id;
    await db.collection(path).doc(items.id).set(items.toMap());
  }

  Future<void> deleteEvent(EventModel items) async {
    await db.collection(path).doc(items.id).delete();
  }
}
