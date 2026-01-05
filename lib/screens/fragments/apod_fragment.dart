import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApodFragment extends StatefulWidget {
  const ApodFragment({super.key});

  @override
  State<ApodFragment> createState() => _ApodFragmentState();
}

class _ApodFragmentState extends State<ApodFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Image of The Day',
        ),
      ),
    );
  }
}
