// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'event_model.dart';
// import 'event_service.dart';

// class EventDetailView extends StatefulWidget {
//   final EventModel event;
//   const EventDetailView({super.key, required this.event});

//   @override
//   State<EventDetailView> createState() => _EventDetailViewState();
// }

// class _EventDetailViewState extends State<EventDetailView> {
//   final subjectController = TextEditingController();
//   final notesController = TextEditingController();
//   final eventService = EventService();

//   @override
//   void initState() {
//     super.initState();
//     subjectController.text = widget.event.subject;
//     notesController.text = widget.event.notes ?? '';
//   }

//   Future<void> pickDateTime({required bool isStart}) async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: isStart ? widget.event.startTime : widget.event.endTime,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2110),
//     );
//     if (pickedDate != null) {
//       if (!mounted) return;

//       final pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.fromDateTime(
//           isStart ? widget.event.startTime : widget.event.endTime,
//         ),
//       );

//       if (pickedTime != null) {
//         setState(() {
//           final newDateTime = DateTime(pickedDate.year, pickedDate.month,
//               pickedDate.day, pickedTime.hour, pickedTime.minute);
//           if (isStart) {
//             widget.event.startTime = newDateTime;
//             if (widget.event.startTime.isAfter(widget.event.endTime)) {
//               widget.event.endTime =
//                   widget.event.startTime.add(const Duration(hours: 1));
//             }
//           } else {
//             widget.event.endTime = newDateTime;
//           }
//         });
//       }
//     }
//   }

//   Future<void> saveEvent() async {
//     widget.event.subject = subjectController.text;
//     widget.event.notes = notesController.text;
//     await eventService.saveEvent(widget.event);
//     if (!mounted) return;
//     Navigator.of(context).pop(true); //trả về màn hình trước đó
//   }

//   Future<void> _deleteEvent() async {
//     await eventService.deleteEvent(widget.event);
//     if (!mounted) return;
//     Navigator.of(context).pop(true); //trở về màn hình trước đó
//   }

//   @override
//   Widget build(BuildContext context) {
//     final al = AppLocalizations.of(context)!;
//     var _saveEvent;
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.event.id == null ? al.addEvent : al.eventDetail),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   controller: subjectController,
//                   decoration: const InputDecoration(labelText: 'Tên sự kiện'),
//                 ),
//                 const SizedBox(height: 16),
//                 ListTile(
//                   title: const Text('Sự kiện cả ngày'),
//                   trailing: Switch(
//                       value: widget.event.isAllDay,
//                       onChanged: (value) {
//                         setState(() {
//                           widget.event.isAllDay = value;
//                         });
//                       }),
//                 ),
//                 //Sử dụng toán tử trải rộng
//                 if (!widget.event.isAllDay) ...[
//                   const SizedBox(height: 16),
//                   ListTile(
//                     title:
//                         Text('Bắt đầu: ${widget.event.fomatedStartTimeString}'),
//                     trailing: const Icon(Icons.calendar_today_outlined),
//                     onTap: () => pickDateTime(isStart: false),
//                   ),
//                   TextField(
//                     controller: notesController,
//                     decoration:
//                         const InputDecoration(labelText: 'Ghi chú sự kiện'),
//                     maxLines: 3,
//                   ),
//                   const SizedBox(height: 24),
//                 ],
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     //Chỉ hiển thị nút xóa nếu không phải sự kiện mới
//                     if (widget.event.id != null)
//                       FilledButton.tonalIcon(
//                           onPressed: _deleteEvent,
//                           label: const Text('Xóa sự kiện')),
//                     FilledButton.tonalIcon(
//                         onPressed: _saveEvent,
//                         label: const Text('Lưu sự kiện')),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }

import 'package:event_manager/Event/event_model.dart';
import 'package:event_manager/Event/event_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Man hinh chi tiet su kien, cho phep them moi or cap nhat
class EventDetailView extends StatefulWidget {
  final EventModel event;
  const EventDetailView({super.key, required this.event});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  final subjectController = TextEditingController();
  final notesController = TextEditingController();
  final eventService = EventService();

  @override
  void initState() {
    super.initState();
    subjectController.text = widget.event.subject;
    notesController.text = widget.event.notes ?? '';
  }

  Future<void> pickDateTime({required bool isStart}) async {
    // Hien hop thoai chon gio
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDate: isStart ? widget.event.startTime : widget.event.endTime,
    );

    if (pickedDate != null) {
      if (!mounted) return;
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            isStart ? widget.event.startTime : widget.event.endTime),
      );

      if (pickedTime != null) {
        setState(() {
          final newDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedDate.hour,
            pickedDate.minute,
          );
          if (isStart) {
            widget.event.startTime = newDateTime;
            if (widget.event.startTime.isAfter(widget.event.endTime)) {
              widget.event.endTime = widget.event.startTime.add(
                const Duration(hours: 1),
              );
            }
          } else {
            widget.event.endTime = newDateTime;
          }
        });
      }
    }
  }

  Future<void> _saveEvent() async {
    widget.event.subject = subjectController.text;
    widget.event.notes = notesController.text;
    await eventService.saveEvent(widget.event);

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  Future<void> _deleteEvent() async {
    await eventService.deleteEvent(widget.event);

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.id == null ? al.addEvent : al.eventDetail),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(labelText: "Tên sự kiện"),
            ),
            const SizedBox(height: 15),
            ListTile(
              title: const Text("Sự kiện cả ngày"),
              trailing: Switch(
                  value: widget.event.isAllDay,
                  onChanged: (value) {
                    setState(() {
                      widget.event.isAllDay = value;
                    });
                  }),
            ),
            if (!widget.event.isAllDay) ...[
              const SizedBox(height: 15),
              ListTile(
                title: Text("Bắt đầu: ${widget.event.formatedStartTimeString}"),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: () => pickDateTime(isStart: true),
              ),
              const SizedBox(height: 15),
              ListTile(
                title: Text("Bắt đầu: ${widget.event.formatedEndTimeString}"),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: () => pickDateTime(isStart: false),
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: "Ghi chú sự kiện"),
                maxLines: 3,
              ),
              const SizedBox(height: 15),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (widget.event.id != null)
                  FilledButton.tonalIcon(
                      onPressed: _deleteEvent,
                      label: const Text("Xóa sự kiện")),
                FilledButton.icon(
                    onPressed: _saveEvent, label: const Text("Lưu sự kiện")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
