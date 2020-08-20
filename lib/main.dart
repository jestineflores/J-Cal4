import 'package:flutter/material.dart';
import 'package:j_cal4/widgets/wrapper.dart';
import 'package:table_calendar/table_calendar.dart';
import 'models/event_firestore_service.dart';
import 'package:provider/provider.dart';

import './widgets/new_event.dart';
import './models/event.dart';
import './services/auth.dart';
import './models/user.dart';

import './widgets/event_info.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'J-Cal4',
        theme:
            ThemeData(primarySwatch: Colors.amber, accentColor: Colors.purple),
        home: Wrapper(),
        routes: {
          "add_event": (_) => NewEvent(),
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  Map<TimeOfDay, List<dynamic>> startTime;
  Map<TimeOfDay, List<dynamic>> endTime;
  // List<dynamic> _selectedTime1;
  // List<dynamic> _selectedTime2;
  List<dynamic> _selectedEvents;
  final AuthService _auth = AuthService();
  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
    // _selectedTime1 = [];
    // _selectedTime2 = [];
    // startTime = {};
    // endTime = {};
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<Post> allEvents) {
    Map<DateTime, List<dynamic>> data = {};
    allEvents.forEach((event) {
      DateTime date = DateTime(
          event.eventDate.year, event.eventDate.month, event.eventDate.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
  }

  // Map<TimeOfDay, List<dynamic>> _groupEvents1(List<Post> allEvents) {
  //   Map<TimeOfDay, List<dynamic>> data = {};
  //   allEvents.forEach((event) {
  //     TimeOfDay selectedTime1 =
  //         TimeOfDay(hour: event.startTime.hour, minute: event.startTime.minute);
  //     if (data[selectedTime1] == null) data[selectedTime1] = [];
  //     data[selectedTime1].add(event);
  //     TimeOfDay selectedTime2 =
  //         TimeOfDay(hour: event.endTime.hour, minute: event.endTime.minute);
  //     if (data[selectedTime2] == null) data[selectedTime2] = [];
  //     data[selectedTime2].add(event);
  //   });
  //   return data;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('J-Cal4', style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Navigator.pushNamed(context, 'add_event'),
            ),
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            )
          ]),
      body: StreamBuilder<List<Post>>(
          stream: eventDatabase.streamList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Post> allEvents = snapshot.data;
              if (allEvents.isNotEmpty) {
                _events = _groupEvents(allEvents);
                // startTime = _groupEvents1(allEvents);
                // endTime = _groupEvents1(allEvents);
              } else {
                _events = {};
                _selectedEvents = [];
                // _selectedTime1 = [];
                // _selectedTime2 = [];
                // startTime = {};
                // endTime = {};
              }
            }
            return SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TableCalendar(
                      events: _events,
                      initialCalendarFormat: CalendarFormat.month,
                      calendarStyle: CalendarStyle(
                          canEventMarkersOverflow: true,
                          todayColor: Colors.amber,
                          selectedColor: Theme.of(context).accentColor,
                          todayStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white)),
                      headerStyle: HeaderStyle(
                        centerHeaderTitle: true,
                        formatButtonDecoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        formatButtonTextStyle: TextStyle(color: Colors.white),
                        formatButtonShowsNext: false,
                      ),
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      onDaySelected: (date, events) {
                        setState(() {
                          _selectedEvents = events;
                          // _selectedTime1 = startTime as List;
                          // _selectedTime2 = endTime as List;
                        });
                      },
                      builders: CalendarBuilders(
                        selectedDayBuilder: (context, date, events) =>
                            Container(
                                margin: const EdgeInsets.all(5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(11)),
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                        todayDayBuilder: (context, date, events) => Container(
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(9)),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      calendarController: _controller,
                    ),
                    ..._selectedEvents.map(
                      (event) => Card(
                        elevation: 5,
                        child: ListTile(
                          title: Text(event.title),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EventInfo(
                                          event: event,
                                        )));
                          },
                        ),
                      ),
                    ),
                    // ..._selectedTime1.map(
                    //   (event) => Card(
                    //     elevation: 5,
                    //     child: ListTile(
                    //       title: Text(event.startTime),
                    //       onTap: () {
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (_) => EventInfo(
                    //                       event: event,
                    //                     )));
                    //       },
                    //     ),
                    //   ),
                    // ),
                    // ..._selectedTime2.map(
                    //   (event) => Card(
                    //     elevation: 5,
                    //     child: ListTile(
                    //       title: Text(event.endTime),
                    //       onTap: () {
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (_) => EventInfo(
                    //                       event: event,
                    //                     )));
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ]),
            );
          }),
    );
  }
}
