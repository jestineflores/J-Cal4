// import 'package:flutter/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

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
