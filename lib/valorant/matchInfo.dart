import 'package:flutter/material.dart';
class MatchDetailScreen extends StatelessWidget {
  final dynamic match;

  MatchDetailScreen({required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Details'),
      ),
      body: Center(
        child: Text('Details for Match ID: ${match['matchId']}'), // Display more details as needed
      ),
    );
  }
}