import 'package:flutter/material.dart';
import 'package:pgi_mobile/screens/Scan/scan_inventory.dart';
import 'package:pgi_mobile/utils/components.dart';

import 'package:page_transition/page_transition.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text('Accueil'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Code pour obtenir le "card button" qui va vous diriger vers
              // l'identification du personnel qui va gérer le stock

              Container(
                padding: const EdgeInsets.all(10),
                width: 220,
                child: MyButtonCard(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.amber,
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const ScanInventory()));
                    },
                    child: Column(
                      children: [
                        Image.asset('assets/icons/inventaire.png'),
                        Ink(
                          child: Container(
                            height: 70,
                            color: const Color.fromRGBO(19, 62, 103, 1),
                            child: const SizedBox.expand(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('Inventaire',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                width: 220,
                padding: const EdgeInsets.all(10),
                child: MyButtonCard(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {},
                    child: Column(
                      children: [
                        Image.asset('assets/icons/reception.png'),
                        Ink(
                          child: Container(
                            height: 70,
                            color: const Color.fromRGBO(19, 62, 103, 1),
                            child: const SizedBox.expand(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('Réception',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
