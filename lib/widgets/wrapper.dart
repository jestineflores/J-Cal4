import 'package:flutter/material.dart';
import 'package:j_cal4/widgets/authenticate/authenticate.dart';
import 'package:provider/provider.dart';

import './authenticate/authenticate.dart';
import '../models/user.dart';
import '../main.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
