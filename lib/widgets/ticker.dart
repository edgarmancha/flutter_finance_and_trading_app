// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../utils.dart';

class NewsTicker extends StatefulWidget {
  final List<String> newsList;

  const NewsTicker({Key? key, required this.newsList}) : super(key: key);

  @override
  _NewsTickerState createState() => _NewsTickerState();
}

class _NewsTickerState extends State<NewsTicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        itemCount: widget.newsList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.newsList[index],
              style: SafeGoogleFont(
                'Roboto',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.5,
                color: GlobalColors.whiteAcc,
              ),
            ),
          );
        },
      ),
    );
  }
}
