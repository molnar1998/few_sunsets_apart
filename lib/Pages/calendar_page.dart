import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:few_sunsets_apart/Data/firebase_servicev2.dart';
import 'package:few_sunsets_apart/Data/user_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<StatefulWidget> createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  final FirebaseDataFetcher _dataFetcher = FirebaseDataFetcher();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our calendar'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              icon: Icon(Icons.arrow_back_ios_new))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _dataFetcher.getMemories(UserData.id),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No appointments available.'));
          } else {
            // Convert Firestore documents to a list of Appointments
            List<Appointment> appointments = snapshot.data!.docs.map((document) {
              try {
                return Appointment(
                  startTime: document.get('date').toDate(),
                  endTime: document.get('date').toDate().add(Duration(hours: 1)),
                  subject: document.get('title') ?? 'No Title',
                  notes: document.get('text') ?? 'No Details',
                  color: Colors.red,
                  recurrenceRule: 'FREQ=YEARLY;BYMONTHDAY=${document.get('date').toDate().day};BYMONTH=${document.get('date').toDate().month};INTERVAL=1;'
                );
              } catch (e) {
                debugPrint('Error parsing document: $e');
                return null;
              }
            }).whereType<Appointment>().toList();

            return SfCalendar(
              view: CalendarView.schedule,
              showDatePickerButton: true,
              dataSource: _AppointmentDataSource(appointments),
              onTap: (CalendarTapDetails details) {
                CalendarElement element = details.targetElement;
                List? appointment = details.appointments;
                if (kDebugMode) {
                  print(appointment?.first.subject);
                }
              }
            );
          }
        },
      ),
    );
  }

  _AppointmentDataSource _getCalendarDataSource() {
    var stream = _dataFetcher.getMemories(UserData.id);
    List<Appointment> appointments = <Appointment>[];
    stream.listen((documents) {
      for(var document in documents.docs){
        try {
          final newAppointment = Appointment(
            startTime: document.get('createdAt').toDate(),
            endTime: document.get('createdAt').toDate().add(Duration(hours: 8)),
            subject: document.get('title') ?? 'No Title',
            notes: document.get('text') ?? 'No Details',
            color: Colors.blue,
            recurrenceRule: "FREQ=YEARLY;INTERVAL=1"
          );

          // Add to appointments list
          appointments.add(newAppointment);

          setState(() {
            _AppointmentDataSource(appointments);
          });
          
        } catch(e) {
          debugPrint('Error parsing document: $e');
        }
      }
    });

    if(appointments.isNotEmpty){
      debugPrint("Have appointment!");
    }

    return _AppointmentDataSource(appointments);
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source){
    appointments = source;
  }
}
