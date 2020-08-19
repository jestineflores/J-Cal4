import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/material.dart';

class Post extends DatabaseItem {
  final String id;
  final String title;
  final String location;
  final DateTime eventDate;
  // final TimeOfDay startTime;
  // final TimeOfDay endTime;

  Post({this.id, this.title, this.location, this.eventDate})
      // this.startTime,
      // this.endTime})
      : super(id);

  factory Post.fromMap(Map data) {
    return Post(
      title: data['title'],
      location: data['location'],
      eventDate: data['event_date'],
      // startTime: data['start_time'],
      // endTime: data['end_time'],
    );
  }

  factory Post.fromDS(String id, Map<String, dynamic> data) {
    return Post(
      id: id,
      title: data['title'],
      location: data['location'],
      eventDate: data['event_date'].toDate(),
      // startTime: data['start_time'],
      // endTime: data['end_time']);
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "location": location,
      "event_date": eventDate,
      // 'start_time': startTime,
      // 'end_time': endTime,
      "id": id,
    };
  }
}
