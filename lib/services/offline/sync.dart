import 'package:date_format/date_format.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';
import 'package:pgi_mobile/services/online/scan_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncData {
  dateOperation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final before = prefs.getString("date_connection");
    DateTime now = DateTime.now();
    String modifiedTime =
        formatDate(now, [yyyy, '-', mm, '-', dd, ' ', hh, ':', nn, ':', ss]);
    final maps = {"now": modifiedTime, "before": before};
    return maps;
  }

  Future<dynamic> synchronizeHistoryAffectation() async {
    Provider provider = Provider();
    final db = await provider.initDB();
    final operation = await dateOperation();
    List<Map<String, dynamic>> maps = [];
    await db.transaction(
      (txn) async {
        maps = await txn.rawQuery('''
        SELECT 
        code_immo_id    ,
        direction_id    ,
        immoStateId     ,
        user_id         ,
        person_id  ,
        observation
       from History_Affected_Material_Inventory
       where time_of_operation between ? and ?
       ''', [operation["before"], operation["now"]]);
      },
    );
    for (var element in maps) {
      await addHistoryAffectedto(
          element["code_immo_id"],
          element["direction_id"],
          element["immoStateId"],
          element["user_id"],
          element["person_id"],
          element["observation"]);
    }

    return maps;
  }

  Future<dynamic> synchronizeHistoryStock() async {
    Provider provider = Provider();
    final db = await provider.initDB();
    List<Map<String, dynamic>> maps = [];
    final operation = await dateOperation();
    await db.transaction(
      (txn) async {
        maps = await txn.rawQuery('''SELECT 
        code_immo_id    ,
        direction_id    ,
        immoStateId     ,
        user_id         ,
        storage_id  ,
        observation
       from History_Stock_Inventory
       where time_of_operation between ? and ?
       ''', [operation["before"], operation["now"]]);
      },
    );
    for (var element in maps) {
      await addHistoryStock(
          element["code_immo_id"],
          element["direction_id"],
          element["immoStateId"],
          element["user_id"],
          element["storage_id"],
          element["observation"]);
    }
    return maps;
  }

  Future<dynamic> synchronizeAffectation() async {
    Provider provider = Provider();
    final db = await provider.initDB();
    List<Map<String, dynamic>> maps = [];
    final operation = await dateOperation();

    await db.transaction(
      (txn) async {
        maps = await txn.rawQuery('''SELECT 
        code_immo_id    ,
        user_id 
       from affectedto
       where added_time between ? and ?
       ''', [operation["before"], operation["now"]]);
      },
    );
    for (var element in maps) {
      await addAffectation(element["code_immo_id"], element["user_id"]);
    }

    return maps;
  }

  Future<dynamic> synchronizeStateImmo() async {
    Provider provider = Provider();
    final db = await provider.initDB();
    final operation = await dateOperation();
    List<Map<String, dynamic>> maps = [];
    await db.transaction(
      (txn) async {
        maps = await txn.rawQuery('''SELECT 
        state,
        code_immo_id
       from immostate
       where modifiedTime between ? and ?
       ''', [operation["before"], operation["now"]]);
      },
    );
    for (var element in maps) {
      await addImmostate(element["state"], element["code_immo_id"]);
    }

    return maps;
  }
}
