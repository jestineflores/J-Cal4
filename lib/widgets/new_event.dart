// import 'package:flutter/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import '../models/event_firestore_service.dart';

import '../models/event.dart';

class NewEvent extends StatefulWidget {
  final Post event;

  const NewEvent({Key key, this.event}) : super(key: key);

  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  TextStyle style = TextStyle(fontFamily: 'Monospace', fontSize: 18);
  TextEditingController _title;
  TextEditingController _location;
  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(
        text: widget.event != null ? widget.event.title : '');
    _location = TextEditingController(
        text: widget.event != null ? widget.event.location : '');
    _eventDate = DateTime.now();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
                child: TextFormField(
                  controller: _title,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "Title",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
                child: TextFormField(
                  controller: _location,
                  style: style,
                  decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
              const SizedBox(height: 11),
              ListTile(
                title: Text('Date'),
                subtitle: Text(
                    "${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}"),
                onTap: () async {
                  DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: _eventDate,
                      firstDate: DateTime(_eventDate.year - 5),
                      lastDate: DateTime(_eventDate.year + 5));
                  if (picked != null) {
                    setState(() {
                      _eventDate = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 9),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Theme.of(context).primaryColor,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                processing = true;
                              });
                              if (widget.event != null) {
                                await eventDatabase
                                    .updateData(widget.event.id, {
                                  'title': _title.text,
                                  'location': _location.text,
                                  'event_date': widget.event.eventDate
                                });
                              } else {
                                await eventDatabase.createItem(Post(
                                    title: _title.text,
                                    location: _location.text,
                                    eventDate: _eventDate));
                              }
                              Navigator.pop(context);
                              setState(() {
                                processing = false;
                              });
                            }
                          },
                          child: Text(
                            "Add Event",
                            style: style.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _location.dispose();
    super.dispose();
  }
}
