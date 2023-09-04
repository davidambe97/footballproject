import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(FootballApp());
}

class FootballApp extends StatefulWidget {
  const FootballApp({super.key});

  @override
  _FootballAppState createState() => _FootballAppState();
}

class _FootballAppState extends State<FootballApp> {
  String mostWinsTeam = '';
  String mostWinsTeamName = '';
  int mostWinsCount = 0;

  @override
  void initState() {
    super.initState();
    fetchMostWinsTeam();
  }

  void fetchMostWinsTeam() async {
    try {
      final matches = await ApiService.fetchMatches();
      final Map<String, int> winsCountMap = {};
      String mostWinsTeam;
      int mostWinsCount = 0;

      for (var match in matches) {
        if (match['score'] == 0) {
          // Skip matches without score details
          continue;
        }
        final int homeGoals = match['score']['fullTime']?['homeTeam'] ?? 0;
        final int awayGoals = match['score']['fullTime']?['awayTeam'] ?? 0;

        String winningTeamId;
        if (homeGoals > awayGoals) {
          winningTeamId = match['homeTeam']['id'].toString();
        } else if (awayGoals > homeGoals) {
          winningTeamId = match['awayTeam']['id'].toString();
        } else {
          // Match is a draw
          continue;
        }

        winsCountMap[winningTeamId] = (winsCountMap[winningTeamId] ?? 0) + 1;
      }

      if (winsCountMap.isNotEmpty) {
        winsCountMap.forEach((team, count) {
          if (count > mostWinsCount) {
            mostWinsTeam = team;
            mostWinsCount = count;
          }
        });
      }

      print('Most Wins Count: $mostWinsCount');

      setState(() {}); // Update the UI with the most wins team
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Most Wins in Last 30 Days'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Team with most wins:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text(
                mostWinsTeamName.isEmpty ? 'Loading...' : mostWinsTeamName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Total wins: $mostWinsCount',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
