import 'package:finance/components/portfolio.dart';
import 'package:finance/components/quick_actions.dart';
import 'package:flutter/material.dart';

class LowerHome extends StatelessWidget {
  const LowerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: const [
          QuickActions(),
          Portfolio(),
        ],
      ),
    );
  }
}
