import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pgi_mobile/screens/History/data_table_history_affectation.dart';
import 'package:pgi_mobile/screens/History/data_table_history_stock.dart';
import 'package:pgi_mobile/screens/Scan/observation.dart';
import 'package:pgi_mobile/screens/test_db/list_affectedto.dart';
import 'package:pgi_mobile/screens/test_db/list_direction.dart';
import 'package:pgi_mobile/screens/test_db/list_genre.dart';
import 'package:pgi_mobile/screens/History/list_history_affectation.dart';
import 'package:pgi_mobile/screens/History/list_history_stock.dart';
import 'package:pgi_mobile/screens/test_db/list_immo.dart';
import 'package:pgi_mobile/screens/test_db/list_immo_state.dart';
import 'package:pgi_mobile/screens/test_db/list_immos_offline.dart';
import 'package:pgi_mobile/screens/test_db/list_log.dart';
import 'package:pgi_mobile/screens/test_db/list_person.dart';
import 'package:pgi_mobile/screens/test_db/list_seats.dart';
import 'package:pgi_mobile/screens/test_db/list_service.dart';
import 'package:pgi_mobile/screens/test_db/list_storage.dart';
import 'package:pgi_mobile/screens/test_db/list_traceability.dart';
import 'package:pgi_mobile/screens/test_db/list_user_offline.dart';
import 'package:pgi_mobile/utils/components.dart';

class MenuTest extends StatelessWidget {
  const MenuTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text('Accueil test'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Code pour obtenir le "card button" qui va vous diriger vers
              // l'identification du personnel qui va gérer le stock

              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const ImmoCodeOffline()),
                  child: const Text("Test immo Offline : vita"),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const ImmoCode()),
                  child: const Text("Test immo Online : vita"),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const UserOffline()),
                  child: const Text("Test user Offline : vita"),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const DirectionList()),
                  child: const Text("Test direction Offline : vita"),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const ServiceList()),
                  child: const Text("Test services Offline : vita "),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const SeatsList()),
                  child: const Text("Test siège : vita "),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const StorageAddressList()),
                  child: const Text("Test adresse de stockage : vita"),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const PersonList()),
                  child: const Text("Test personne : en Vita "),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const SexList()),
                  child: const Text("Test genre personne : Vita "),
                ),
              ),

              SizedBox(
                child: ElevatedButton(
                  onPressed: () =>
                      Get.to(() => const TraceabilityServiceList()),
                  child: const Text("Test traceability service : Vita"),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const AffectedtoList()),
                  child: const Text("Test affectation : Vita"),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const HistoryaffectationList()),
                  child: const Text(
                      "Test Historique inventaire affectation : Vita"),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const HistoryStockList()),
                  child: const Text(
                      "Test Historique inventaire stock matériel : Vita"),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const UserOffline()),
                  child: const Text("Test userAffected : Vita"),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const GridStock()),
                  child: const Text("Test datatables stock : Ok"),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const GridAffectation()),
                  child: const Text("Test datatable affectation : Vita"),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const Logs()),
                  child: const Text("Test Log : ??"),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const ImmostateList()),
                  child: const Text("Test Immo state : ??"),
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const Observation()),
                  child: const Text("Test observation : ??"),
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: fDrawer(context),
    );
  }
}
