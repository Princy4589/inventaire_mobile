import 'package:flutter/material.dart';
import 'package:pgi_mobile/screens/Menu/menu.dart';

import 'package:pgi_mobile/services/offline/database_helper.dart';
import 'package:pgi_mobile/services/offline/user_service_offline.dart';
import 'package:pgi_mobile/services/offline/welcome_service.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Screens(),
    );
  }
}

class Screens extends StatefulWidget {
  const Screens({Key? key}) : super(key: key);

  @override
  State<Screens> createState() => _Screens();
}

class _Screens extends State<Screens> {
  String name = "";

  //Fonction qui va permettre de récupérer les données
  //venant du base de données serveur vers la base de données locale mobile
  Future<List<dynamic>> fetchData() async {
    OfflineService offline = OfflineService();
    Provider imo = Provider();
    // fetch data from server database

    final immo = await offline.fetchImmo();

    final userlist = await offline.fetchUsers();

    final direction = await offline.fetchDirections();

    final service = await offline.fetchServices();

    final seat = await offline.fetchSeats();

    final storage = await offline.fetchStorageAddress();

    final person = await offline.fetchPersons();

    final sex = await offline.fetchGenre();

    final traceability = await offline.fetchTraceability();

    final affectation = await offline.fetchAffectation();

    await imo.insert(immo, "code_immo");

    await imo.insert(userlist, "user");

    await imo.insert(direction, "direction");

    await imo.insert(service, "service");

    await imo.insert(seat, "seats");

    await imo.insert(storage, "storage_address");

    await imo.insert(person, "person");

    await imo.insert(sex, "sex");

    await imo.insert(traceability, "traceability_service");

    await imo.insert(affectation, "affectedto");

    return affectation;
  }

  //Récupère le nom de l'utilisateur en train de se connecter
  loadUserName() async {
    Welcome welcome = Welcome();
    final list = await welcome.userWelcomeScreenService();
    for (var element in list) {
      name = element["name"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: loadData(context),
    );
  }

  //widget pour récupérer les données du fonction
  //fetchData et affiche un écran de chargement en
  //attendant
  Widget loadData(BuildContext context) {
    setState(() {
      //charge le nom de l'utilisateur connecté
      loadUserName();
    });
    return FutureBuilder<List<dynamic>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return loadingScreen(context);
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                Text("Chargement..."),
              ],
            ),
          );
        }
      },
    );
  }

  Widget loadingScreen(BuildContext context) {
    loadUserName();
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        color: const Color.fromRGBO(19, 62, 103, 1),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(50, 100, 50, 50),
              child: const Text(
                "Bienvenue",
                style: TextStyle(fontSize: 38, color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
              child: Text(
                "$name,",
                style: const TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
            Expanded(
              flex: 1,
              child: Image.asset("assets/icons/waving.png"),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              height: 100,
              child: OutlinedButton(
                clipBehavior: Clip.antiAlias,
                autofocus: true,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(width: 4.0, color: Colors.white),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
                child: const Text(
                  "Continuer",
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Menu()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
