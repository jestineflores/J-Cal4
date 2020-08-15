import 'package:flutter/material.dart';
import '../models/event.dart';

class EventList extends StatelessWidget {
  final Post event;

  const EventList({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              event.title,
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 18),
            Text(event.location)
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';

// import '../models/event.dart';

// class EventInfo extends StatelessWidget {
//   final Post event;

//   const EventInfo({Key key, this.event}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Enter Location'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               event.title,
//               style: Theme.of(context).textTheme.headline1,
//             ),
//             SizedBox(height: 19),
//             Text(event.location)
//           ],
//         ),
//       ),
//     );
//   }
// }
