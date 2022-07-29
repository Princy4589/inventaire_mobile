import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/screens/AffectationInventory/immo_state.dart';
import 'package:pgi_mobile/screens/AffectationInventory/summary_material.dart';
import 'package:pgi_mobile/services/online/scan_services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckMaterial extends StatelessWidget {
  const CheckMaterial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text('Scan Matériel'),
      ),
      body: const QrCodeWidget(),
      endDrawer: fDrawer(context),
    );
  }
}

class QrCodeWidget extends StatefulWidget {
  const QrCodeWidget({Key? key}) : super(key: key);
  @override
  State<QrCodeWidget> createState() => _QrCodeWidget();
}

class _QrCodeWidget extends State<QrCodeWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  final userEntry = {};
  final List<Map<String, dynamic>> _stateItem = [
    {
      'value': 'BON ETAT',
      'label': 'Bon état',
    },
    {
      'value': 'MAUVAIS ETAT',
      'label': 'Mauvais état',
    },
    {
      'value': 'ETAT MOYEN',
      'label': 'Etat moyen',
    },
    {
      'value': 'TRES BON ETAT',
      'label': 'Excellent état',
    },
  ];

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void readQr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (result != null) {
      controller!.pauseCamera();
      userEntry['code_immo'] = result!.code;
      prefs.setString("code_immo", userEntry['code_immo']);

      controller!.dispose();
    }
  }

  getEntryItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userEntry['Directions'] = prefs.getString('Directions');
    userEntry['Service'] = prefs.getString('Service');
    userEntry['HQ'] = prefs.getString('HQ');
    return userEntry;
  }

  setImmo(immocode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("state", userEntry['state']);
    final list = await getImmoId(immocode);

    prefs.setString("code_immo", immocode);

    if (list is bool) {
      return list;
    } else {
      list.forEach((element) {
        if (element is Map<String, dynamic>) {
          element.forEach((key, value) {
            if (value != null) {
              if (key == 'code_immo_id') {
                userEntry['code_immo_id'] = value.toString();
                prefs.setString("code_immo_id", value.toString());
              }
            }
          });
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RecapInfo()));
      });
      return list;
    }
  }

  Widget loadImmo(String immoCode) {
    final onComplete = SnackBar(
      content: const Text("L'opération s'est complété avec succès"),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
    );
    return FutureBuilder(
        future: setImmo(immoCode),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ScaffoldMessenger.of(context).showSnackBar(onComplete)
                as ScaffoldMessenger;
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    readQr();
    return Center(
      child: loadEntry(),
    );
  }

  Widget scanMaterial(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              width: 370,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 290,
                      width: 290,
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MaterialStateImmo()));
                        },
                        icon: const Icon(Icons.handyman),
                        label: const Text("Entrer le code manuellement"),
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(19, 62, 103, 1),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              height: 50,
              width: 300,
              child: const Center(
                child: Text('Faites un scan'),
              ),
            ),
            SizedBox(
              height: 61,
              width: 300,
              child: Column(
                children: [
                  (result != null)
                      ? TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Code Immo : ${result!.code}',
                            border: const OutlineInputBorder(),
                          ),
                        )
                      : const TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Code Immo : ',
                            border: OutlineInputBorder(),
                          ),
                        ),
                ],
              ),
            ),
            Container(
              width: 300,
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: SelectFormField(
                type: SelectFormFieldType.dropdown,
                labelText: 'Etat Matériel',
                items: _stateItem,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_tree),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  isDense: true,
                  border: OutlineInputBorder(),
                  hintText: 'Etat Matériel',
                ),
                onChanged: (value) {
                  userEntry['state'] = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(19, 62, 103, 1),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  if (result != null) {
                    loadImmo(userEntry['code_immo']);
                  } else {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("Erreur"),
                        content: const Text("Veuillez scanner un code QR"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Ok'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Suivant'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadEntry() {
    return FutureBuilder(
        future: getEntryItems(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return scanMaterial(context);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
