import 'package:flutter/material.dart';
import '../models/event.dart';

class EventInfo extends StatelessWidget {
  final Post event;

  const EventInfo({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Location'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(event.title, style: TextStyle(fontSize: 23)),
            SizedBox(height: 20.0),
            Text(event.location)
          ],
        ),
      ),
    );
  }
}
