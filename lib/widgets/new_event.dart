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
  TextStyle style = TextStyle(fontFamily: 'Monospace', fontSize: 16);
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
        title: Text(widget.event != null ? "Edit Event" : "Add Event"),
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
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _title,
                  validator: (value) =>
                      (value.isEmpty) ? "Please Enter title" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "Title",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _location,
                  minLines: 2,
                  maxLines: 5,
                  validator: (value) =>
                      (value.isEmpty) ? "Enter Location" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "Location",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
              const SizedBox(height: 9),
              ListTile(
                title: Text("Date (YYYY-MM-DD)"),
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
              SizedBox(height: 10.0),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Material(
                        elevation: 6.0,
                        borderRadius: BorderRadius.circular(27.0),
                        color: Theme.of(context).accentColor,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                processing = true;
                              });
                              if (widget.event != null) {
                                await eventDBS.updateData(widget.event.id, {
                                  "title": _title.text,
                                  "description": _location.text,
                                  "event_date": widget.event.eventDate
                                });
                              } else {
                                await eventDBS.createItem(Post(
                                    title: _title.text,
                                    location: _location.text,
                                    eventDate: DateTime.now()));
                              }
                              Navigator.pop(context);
                              setState(() {
                                processing = false;
                              });
                            }
                          },
                          child: Text(
                            "Save",
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
// class NewEvent extends StatefulWidget {
//   final Function addEvent;

//   NewEvent(this.addEvent);

//   @override
//   _NewEventState createState() => _NewEventState();
// }

// class _NewEventState extends State<NewEvent> {
//   final titleController = TextEditingController();
//   final locationController = TextEditingController();
//   DateTime ;
//   DateTime endTime;

//   void submitData() {
//     final enteredTitle = titleController.text;
//     final enteredLocation = locationController.text;
//     final enteredStartTime = selectedDate;
//     final enteredEndTime = endTime;

//     widget.addEvent(
//       enteredTitle,
//       enteredLocation,
//       enteredStartTime,
//       enteredEndTime,
//     );

//     Navigator.of(context).pop();
//   }

//   void presentDatePicker() {
//     showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//     ).then((pickedDate) {
//       if (pickedDate == null) {
//         return;
//       }
//       setState(() {
//         selectedDate = pickedDate;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Card(
//         elevation: 5,
//         child: Container(
//           padding: EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               TextField(
//                 controller: titleController,
//                 onSubmitted: (_) => submitData(),
//               ),
//               TextField(
//                 decoration: InputDecoration(labelText: 'Locatiom'),
//                 controller: locationController,
//                 keyboardType: TextInputType.number,
//                 onSubmitted: (_) => submitData(),
//               ),
//               Container(
//                 height: 70,
//                 child: Row(children: <Widget>[
//                   Expanded(
//                     child: Text(
//                       'Picked Date: ${DateFormat.yMd().format(selectedDate)}',
//                     ),
//                   ),
//                   FlatButton(
//                     textColor: Theme.of(context).primaryColor,
//                     child: Text('Choose Date'),
//                     onPressed: presentDatePicker,
//                   )
//                 ]),
//               ),
//               RaisedButton(
//                 child: Text('Add Event'),
//                 color: Theme.of(context).primaryColor,
//                 textColor: Theme.of(context).textTheme.button.color,
//                 onPressed: submitData,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
