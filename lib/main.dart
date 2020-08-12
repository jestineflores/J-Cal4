import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import './widgets/new_event.dart';
import './models/event.dart';

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
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Event> userEvents = [];
  CalendarController _calendarController;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
    _selectedEvents = [];
    _eventController = TextEditingController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  void _addNewEvent(
      String title, String location, DateTime startTime, DateTime endTime) {
    final newEvent = Event(
      title: title,
      location: location,
      startTime: startTime,
      endTime: endTime,
      id: DateTime.now().toString(),
    );

    setState(() {
      userEvents.add(newEvent);
    });
  }

  void _startAddNewEvent(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () => _addNewEvent,
          behavior: HitTestBehavior.opaque,
          child: Container(
              child: Column(children: <Widget>[
            TextField(
              controller: _eventController,
            ),
            FlatButton(
              child: Text('Save'),
              onPressed: () {
                if (_eventController.text.isEmpty) return;
                setState(
                  () {
                    if (_events[_calendarController.selectedDay] != null) {
                      _events[_calendarController.selectedDay]
                          .add(_eventController.text);
                    } else {
                      _events[_calendarController.selectedDay] = [
                        _eventController.text
                      ];
                    }
                    _eventController.clear();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ])),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('J-Cal4'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewEvent(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                  fontSize: 12,
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
          ..._selectedEvents.map(
            (event) => ListTile(
              title: Text(event),
            ),
          ),
        ],
      )),
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
