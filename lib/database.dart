import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';

class DatabaseHelper {
  late PostgreSQLConnection connection;

  Future<void> connect() async {
    connection = PostgreSQLConnection(
      'localhost', 5432, 'mood_tracker',
      username: 'postgres',
      password: 'catalina',
    );
    await connection.open();
  }

  Future<void> insertUser(String email, String password) async {
    await connection.query(
      'INSERT INTO users (email, password) VALUES (@email, @password)',
      substitutionValues: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<void> insertUserData(
      int userId,
      String dailyResume,
      int hoursSlept,
      int exerciseTime,
      String dayEmotion,
      String person,
      String weather,
      List<String> emotions,
      {DateTime? date}
      ) async {
    date ??= DateTime.now();
    await connection.query(
      '''
      INSERT INTO user_data 
      (user_id, dailyResume, hoursSlept, exerciseTime, dayEmotion, person, weather, emotions, date)
      VALUES (@userId, @dailyResume, @hoursSlept, @exerciseTime, @dayEmotion, @person, @weather, @emotions, @date)
      ''',
      substitutionValues: {
        'userId': userId,
        'dailyResume': dailyResume,
        'hoursSlept': hoursSlept,
        'exerciseTime': exerciseTime,
        'dayEmotion': dayEmotion,
        'person': person,
        'weather': weather,
        'emotions': emotions.join(', '),
        'date': date.toIso8601String(),
      },
    );
  }

  Future<List<Map<String, dynamic>>> getUserData(int userId) async {
    var result = await connection.query(
      'SELECT * FROM user_data WHERE user_id = @userId',
      substitutionValues: {'userId': userId},
    );
    List<Map<String, dynamic>> userData = [];
    for (var row in result) {
      userData.add({
        'dailyResume': row[2],
        'hoursSlept': row[3],
        'exerciseTime': row[4],
        'dayEmotion': row[5],
        'person': row[6],
        'weather': row[7],
        'emotions': (row[8] as String).split(', '),
        'date': row[9],
      });
    }
    return userData;
  }

  Future<List<Map<String, dynamic>>> getUserDataByEmail(String email) async {
    var result = await connection.query(
      'SELECT * FROM users WHERE email = @email',
      substitutionValues: {'email': email},
    );
    return result.isEmpty
        ? []
        : result.map((row) {
      return {
        'email': row[0],
        'password': row[1],
      };
    }).toList();
  }

  Future<void> addUser(String email, String password) async {
    await connection.query(
      'INSERT INTO users (email, password) VALUES (@email, @password)',
      substitutionValues: {'email': email, 'password': password},
    );
  }

  Future<List<Map<String, dynamic>>> queryUserDataForDateRange(DateTime startDate, DateTime endDate) async {
    String start = DateFormat('yyyy-MM-dd').format(startDate);
    String end = DateFormat('yyyy-MM-dd').format(endDate);

    var result = await connection.query(
      '''
      SELECT * FROM user_data 
      WHERE date >= @start AND date <= @end
      ''',
      substitutionValues: {
        'start': start,
        'end': end,
      },
    );
    List<Map<String, dynamic>> userData = [];
    for (var row in result) {
      userData.add({
        'dailyResume': row[2],
        'hoursSlept': row[3],
        'exerciseTime': row[4],
        'dayEmotion': row[5],
        'person': row[6],
        'weather': row[7],
        'emotions': (row[8] as String).split(', '),
      });
    }
    return userData;
  }


  Future<void> close() async {
    await connection.close();
  }
}
