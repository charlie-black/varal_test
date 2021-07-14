

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:varal_test/pages/user_info.dart';

class SuccessPage extends StatefulWidget {
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Success Screen",style: TextStyle(color: Colors.yellow),),backgroundColor: Colors.deepPurple,),
      body: Center(
        child: Column(
          children: [
            Text("Successfully Completed Transaction"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(onPressed: (){},
                child: Text("Back To Homepage",style: TextStyle(color: Colors.yellow),),
                color: Colors.deepPurple,
              ),
            )
          ],
        ),

      ),
    );
  }
}
