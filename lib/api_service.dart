import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = 'a2bfb542b98346b6a1192aed84f20c1d';
  static const String baseUrl = 'https://api.football-data.org/v4/';

  static Future<List<Map<String, dynamic>>> fetchMatches() async {
    final String endpoint = 'matches';
    final String today = DateTime.now().toString().split(' ')[0];
    final String thirtyDaysAgo = DateTime.now().subtract(Duration(days: 10)).toString().split(' ')[0];

    final Uri url = Uri.parse('$baseUrl$endpoint?dateFrom=$thirtyDaysAgo&dateTo=$today');

    final response = await http.get(url, headers: {'X-Auth-Token': apiKey});
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final List<dynamic> matches = decodedData['matches'];

      final List<Map<String, dynamic>> processedMatches = [];

      for (var match in matches) {
        final Map<String, dynamic> homeTeam = match['homeTeam'];
        final Map<String, dynamic> awayTeam = match['awayTeam'];
        final Map<String, dynamic> score = match['score'];
        final String winner = score['winner'];

        final Map<String, dynamic> processedMatch = {
          'homeTeamId': homeTeam['id'],
          'homeTeamName': homeTeam['name'],
          'awayTeamId': awayTeam['id'],
          'awayTeamName': awayTeam['name'],
          'winner': winner,
        };

        processedMatches.add(processedMatch);
      }

      return processedMatches;
    } else {
      throw Exception('Failed to fetch matches.');
    }
  }
}
