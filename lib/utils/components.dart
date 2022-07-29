import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pgi_mobile/screens/History/data_table_history_affectation.dart';
import 'package:pgi_mobile/screens/History/data_table_history_stock.dart';
import 'package:pgi_mobile/screens/Menu/menu.dart';
import 'package:pgi_mobile/screens/Menu/menu_inventory.dart';
import 'package:pgi_mobile/screens/SignIn/signin.dart';
import 'package:pgi_mobile/screens/test_db/menu_test.dart';
import 'package:pgi_mobile/services/offline/sync.dart';
import 'package:pgi_mobile/services/online/signin_service.dart';

//Custom Appbar
class MyAppbar extends AppBar {
  MyAppbar({Key? key, Widget? title})
      : super(
          key: key,
          title: title,
          backgroundColor: const Color.fromRGBO(19, 62, 103, 1),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          actions: <Widget>[
            Builder(
              builder: (context) => IconButton(
                  onPressed: () async {
                    var connectivityResult =
                        await (Connectivity().checkConnectivity());
                    switch (connectivityResult) {
                      case ConnectivityResult.bluetooth:
                        break;
                      case ConnectivityResult.wifi:
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Row(
                            children: const <Widget>[
                              Icon(Icons.wifi),
                              Text("Connecter au réseau wifi")
                            ],
                          ),
                        ));
                        SyncData sync = SyncData();

                        await sync.synchronizeHistoryStock().whenComplete(() =>
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 2),
                              content: Row(
                                children: const <Widget>[
                                  Icon(Icons.check),
                                  Text(" Historique stock synchronisée")
                                ],
                              ),
                            )));
                        await sync.synchronizeHistoryAffectation().whenComplete(
                            () => ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  duration: const Duration(seconds: 2),
                                  content: Row(
                                    children: const <Widget>[
                                      Icon(Icons.check),
                                      Text(
                                          " Historique affectation synchronisée")
                                    ],
                                  ),
                                )));

                        await sync.synchronizeAffectation().whenComplete(() =>
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 2),
                              content: Row(
                                children: const <Widget>[
                                  Icon(Icons.check),
                                  Text(" Affectation synchroniser")
                                ],
                              ),
                            )));
                        await sync.synchronizeStateImmo().whenComplete(() =>
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 2),
                              content: Row(
                                children: const <Widget>[
                                  Icon(Icons.check),
                                  Text(" Etat matériel synchroniser")
                                ],
                              ),
                            )));
                        break;
                      case ConnectivityResult.ethernet:
                        break;
                      case ConnectivityResult.mobile:
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Row(
                            children: const <Widget>[
                              Icon(Icons.network_cell_rounded),
                              Text(" Connecter au réseau mobile")
                            ],
                          ),
                        ));
                        break;
                      case ConnectivityResult.none:
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Row(
                            children: const <Widget>[
                              Icon(Icons.wifi_off_outlined),
                              Text(" Aucun réseau détécter")
                            ],
                          ),
                        ));
                        break;
                    }
                  },
                  icon: const Icon(Icons.sync)),
            ),
            Builder(
              builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(Icons.menu)),
            ),
          ],
        );
}

//Custom button card
class MyButtonCard extends Card {
  MyButtonCard({Key? key, child})
      : super(
            key: key,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child: child);
}

class MyRoundedButtonCard extends Card {
  const MyRoundedButtonCard({Key? key, child})
      : super(
          key: key,
          clipBehavior: Clip.antiAlias,
          shape: const CircleBorder(),
          child: child,
        );
}

//Custom Drawer

Widget fDrawer(context) {
  return Drawer(
    backgroundColor: const Color.fromRGBO(19, 62, 103, 1),
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          margin: EdgeInsets.only(bottom: 0.2),
          decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage("assets/icons/fid_logo.png")),
            color: Colors.white,
          ),
          child: Text(
            '',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(
          child: Column(
            children: [
              ListTile(
                title: const Text(
                  'Accueil',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Menu()),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Menu Inventaire',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.menu_open,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MenuInventory()),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Historique affectation',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.person_search_sharp,
                  color: Colors.white,
                ),
                onTap: () {
                  onLogout();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GridAffectation(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Historique Stock',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.rectangle_outlined,
                  color: Colors.white,
                ),
                onTap: () {
                  onLogout();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GridStock()),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Test',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.telegram_sharp,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MenuTest()),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'decrypt',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.assessment,
                  color: Colors.white,
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'Se déconnecter',
                  style: TextStyle(color: Colors.white),
                ),
                leading: const Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
                onTap: () {
                  onLogout();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignIn()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
