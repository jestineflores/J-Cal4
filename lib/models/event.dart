import 'package:firebase_helpers/firebase_helpers.dart';

class Post extends DatabaseItem {
  final String id;
  final String title;
  final String location;
  final DateTime eventDate;

  Post({this.id, this.title, this.location, this.eventDate}) : super(id);

  factory Post.fromMap(Map data) {
    return Post(
      title: data['title'],
      location: data['location'],
      eventDate: data['event_date'],
    );
  }

  factory Post.fromDS(String id, Map<String, dynamic> data) {
    return Post(
      id: id,
      title: data['title'],
      location: data['location'],
      eventDate: data['event_date'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "location": location,
      "event_date": eventDate,
      "id": id,
    };
  }
}
