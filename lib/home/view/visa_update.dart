import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VisaUpdate extends StatefulWidget {
  const VisaUpdate({Key? key}) : super(key: key);
  @override
  State<VisaUpdate> createState() => _VisaUpdateState();
}

class _VisaUpdateState extends State<VisaUpdate> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(

        body: const Center(
          child: Text('Visa Requirement search feature not available '),
        ),
      ),
    );
  }
}