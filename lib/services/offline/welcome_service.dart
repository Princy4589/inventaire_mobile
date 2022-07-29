import 'package:pgi_mobile/services/offline/database_helper.dart';

class Welcome {
  Provider provider = Provider();
  int userId = 0;
  Future<dynamic> userWelcomeScreenService() async {
    final logUser = await provider.getLastLogFromDB();
    final db = await provider.initDB();
    List<Map<String, dynamic>> maps = [];

    for (var element in logUser) {
      userId = element.userId;
    }

    await db.transaction(
      (txn) async {
        maps = await txn.rawQuery("""
        SELECT person.last_name as 'name' from person 
        INNER JOIN user ON person.person_id = user.user_id
        WHERE user.user_id =? """, [userId]);
      },
    );
    return maps;
  }
}
