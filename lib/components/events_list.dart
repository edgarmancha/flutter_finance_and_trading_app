import 'package:finance/components/events_card.dart';
import 'package:finance/components/events_card_gbp.dart';

import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../utils.dart';

class EventsList extends StatefulWidget {
  const EventsList({super.key});

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
          child: Text(
            'Upcoming Events',
            style: SafeGoogleFont(
              'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.5,
              color: GlobalColors.secondaryColor,
            ),
          ),
        ),
        Container(
            color: Colors.amberAccent,
            height: 600,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: const [EventsCard(), GbpEvent(), EventsCard()],
            ))
      ],
    );
  }
}
