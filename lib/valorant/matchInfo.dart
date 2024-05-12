import 'package:flutter/material.dart';

class MatchInfo extends StatelessWidget {
  final Map<String, dynamic> match;

  MatchInfo({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Directly accessing the red and blue teams from the match data
    List<dynamic> redTeam = match['players']['red'] as List<dynamic>;
    List<dynamic> blueTeam = match['players']['blue'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text("Match Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildMatchDetails(match),
            SizedBox(height: 10),
            Text('Red Team', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
            buildPlayerList(redTeam),
            SizedBox(height: 10),
            Text('Blue Team', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            buildPlayerList(blueTeam),
          ],
        ),
      ),
    );
  }

  Widget buildMatchDetails(Map<String, dynamic> matchData) {
    return Column(
      children: [
        Text('Map: ${matchData['metadata']['map']}', style: TextStyle(fontSize: 16)),
        Text('Mode: ${matchData['metadata']['mode']}', style: TextStyle(fontSize: 16)),
        Text('Score: ${matchData['teams']['red']['rounds_won']} - ${matchData['teams']['blue']['rounds_won']}', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget buildPlayerList(List<dynamic> team) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: team.length,
      itemBuilder: (context, index) {
        var player = team[index];
        return Card(
          child: ListTile(
            title: Text('${player['name']}#${player['tag']}'),
            subtitle: Text('Agent: ${player['character']} - Rank: ${player['currenttier_patched']}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Kills: ${player['stats']['kills']}'),
                Text('Deaths: ${player['stats']['deaths']}'),
                Text('Assists: ${player['stats']['assists']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
