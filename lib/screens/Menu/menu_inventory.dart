import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pgi_mobile/screens/VerificationInventory/check.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/screens/AffectationInventory/affected_material.dart';
import 'package:pgi_mobile/screens/StockInventory/add_stock.dart';

class MenuInventory extends StatelessWidget {
  const MenuInventory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text('Menu Inventaire'),
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
                width: 256,
                height: 256,
                child: MyRoundedButtonCard(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(40),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const Staff()));
                    },
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 40,
                          left: 0,
                          child: Image.asset(
                            'assets/icons/personnel.png',
                            width: 230,
                          ),
                        ),
                        Positioned(
                          top: 170,
                          right: 0,
                          child: Ink(
                            child: Container(
                              width: 220,
                              height: 60,
                              color: const Color.fromRGBO(19, 62, 103, 1),
                              child: const SizedBox.expand(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text('Affectation',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 21)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Code pour obtenir le "card button" qui va vous diriger vers le
              // inventaire de stock
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 256,
                      height: 256,
                      child: MyRoundedButtonCard(
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: const CheckMaterial()));
                          },
                          child: Stack(
                            children: [
                              Positioned(
                                right: 0,
                                bottom: 25,
                                child: Image.asset(
                                  'assets/icons/checked.png',
                                  width: 230,
                                ),
                              ),
                              Positioned(
                                top: 170,
                                right: 0,
                                child: Ink(
                                  child: Container(
                                    width: 220,
                                    height: 60,
                                    color: const Color.fromRGBO(19, 62, 103, 1),
                                    child: const SizedBox.expand(
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Text('Vérification',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22)),
                                      ),
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
                      padding: const EdgeInsets.all(10),
                      width: 256,
                      height: 256,
                      child: MyRoundedButtonCard(
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: const AddStock()));
                          },
                          child: Stack(
                            children: [
                              Positioned(
                                right: 0,
                                bottom: 40,
                                child: Image.asset(
                                  'assets/icons/stock.png',
                                  width: 230,
                                ),
                              ),
                              Positioned(
                                top: 170,
                                right: 0,
                                child: Ink(
                                  child: Container(
                                    width: 220,
                                    height: 60,
                                    color: const Color.fromRGBO(19, 62, 103, 1),
                                    child: const SizedBox.expand(
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Text('Stock',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 21)),
                                      ),
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
            ],
          ),
        ),
      ),
      endDrawer: fDrawer(context),
    );
  }
}
