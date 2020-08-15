import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'models/event_firestore_service.dart';

import './widgets/new_event.dart';
import './models/event.dart';
import './widgets/event_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'J-Cal4',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor),
            ),
      ),
      home: Home(),
      routes: {
        'add_event': (_) => NewEvent(),
      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<NewEvent> userEvents = [];
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  // TextEditingController _eventController;
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
    _selectedEvents = [];
    // _eventController = TextEditingController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
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

  // Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
  //   Map<String, dynamic> newMap = {};
  //   map.forEach((key, value) {
  //     newMap[key.toString()] = map[key];
  //   });
  //   return newMap;
  // }

  // Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
  //   Map<DateTime, dynamic> newMap = {};
  //   map.forEach((key, value) {
  //     newMap[DateTime.parse(key)] = map[key];
  //   });
  //   return newMap;
  // }

  // void _addNewEvent(
  //     String title, String location, DateTime startTime, DateTime endTime) {
  //   final newEvent = Event(
  //     title: title,
  //     location: location,
  //     startTime: startTime,
  //     endTime: endTime,
  //     id: DateTime.now().toString(),
  //   );

  //   setState(() {
  //     userEvents.add(newEvent);
  //   });
  // }

  // void submitData() {
  //   if (titleController.text.isEmpty) {
  //     return;
  //   }
  //   final enteredTitle = titleController.text;
  //   final enteredAmount = double.parse(amountController.text);

  //   if (enteredTitle.isEmpty || enteredAmount <= 0 || selectedDate == null) {
  //     return;
  //   }
  //   widget.addTx(
  //     enteredTitle,
  //     enteredAmount,
  //     selectedDate,
  //   );

  //   Navigator.of(context).pop();
  // }

  // void _startAddNewEvent(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (_) {
  //       return GestureDetector(
  //         onTap: () {},
  //         behavior: HitTestBehavior.opaque,
  //         child: Container(
  //             child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //               TextField(
  //                 controller: _eventController,
  //                 decoration: InputDecoration(labelText: 'Event'),
  //               ),
  //               FlatButton(
  //                 child: Text('Add Event'),
  //                 color: Theme.of(context).primaryColor,
  //                 textColor: Theme.of(context).textTheme.button.color,
  //                 onPressed: () {
  //                   if (_eventController.text.isEmpty) return;
  //                   setState(
  //                     () {
  //                       if (_events[_calendarController.selectedDay] != null) {
  //                         _events[_calendarController.selectedDay]
  //                             .add(_eventController.text);
  //                       } else {
  //                         _events[_calendarController.selectedDay] = [
  //                           _eventController.text
  //                         ];
  //                       }
  //                       _eventController.clear();
  //                       Navigator.pop(context);
  //                     },
  //                   );
  //                 },
  //               ),
  //             ])),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('J-Cal4'),
      ),
      body: StreamBuilder<List<Post>>(
        stream: eventDBS.streamList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Post> allEvents = snapshot.data;
            if (allEvents.isNotEmpty) {
              _events = _groupEvents(allEvents);
            } else {
              _events = {};
              _selectedEvents = [];
            }
          }
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.add),
          //     onPressed: () => _groupEvents(AllEvents)
          //   ),
          // ],
          return SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TableCalendar(
                initialCalendarFormat: CalendarFormat.month,
                events: _events,
                calendarStyle: CalendarStyle(
                  todayColor: Colors.amber,
                  selectedColor: Theme.of(context).primaryColor,
                  todayStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                headerStyle: HeaderStyle(
                  centerHeaderTitle: true,
                  formatButtonDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.amber,
                  ),
                  formatButtonShowsNext: false,
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                ),
                startingDayOfWeek: StartingDayOfWeek.sunday,
                onDaySelected: (date, events) {
                  setState(() {
                    _selectedEvents = events;
                  });
                },
                builders: CalendarBuilders(
                  selectedDayBuilder: (context, date, events) => Container(
                    margin: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.black, width: 1.0),
                    ),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  todayDayBuilder: (context, date, events) => Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.black, width: 1.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                calendarController: _calendarController,
              ),
              ..._selectedEvents.map((event) => ListTile(
                  title: Text(event.title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventList(
                          event: event,
                        ),
                      ),
                    );
                  })),
            ],
          ));
        },
      ),
    );

    //   _showAddDialog() {
    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         content: TextField(
    //           controller: _eventController,
    //         ),
    //         actions: <Widget>[
    //           FlatButton(
    //           child: Text('Save'),
    //           onPressed: () {
    //             if (_eventController.text.isEmpty) return;
    //             setState(() {
    //               if (_events[_calendarController.selectedDay] != null){
    //                   _events[_calendarController.selectedDay].add(_eventController.text);
    //             } else{
    //               _events[_calendarController.selectedDay] =
    //               [_eventController.text];
    //             }
    //             _eventController.clear();
    //             Navigator.pop(context);
    //             });

    //             }),
    //       ],
    //       ),
    //     );
    //   },
    // );
  }
}
