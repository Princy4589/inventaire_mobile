import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pgi_mobile/screens/Scan/material_property.dart';

import 'package:pgi_mobile/screens/Scan/search_material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/services/online/scan_services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Déclarer ici pour être utilisé par "material_property.dart"
//Pour éviter l'utilisation trop fréquente du localStorage
final userEntry = {};

class ScanInventory extends StatelessWidget {
  const ScanInventory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        content: Row(
          children: const <Widget>[
            CircularProgressIndicator(),
            Text("  Chargement...")
          ],
        ),
      ));
      await setImmo(userEntry['code_immo']).whenComplete(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MaterialProperty(),
          ),
        );
      });
    }
  }

  Future<dynamic> setImmo(immocode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final list = await getImmoId(immocode);

    prefs.setString("code_immo", immocode);
    userEntry['code_immo'] = immocode;
    if (list is bool) {
      return list;
    } else {
      list.forEach((element) {
        if (element is Map<String, dynamic>) {
          element.forEach((key, value) {
            if (value != null) {
              if (key == 'code_immo_id') {
                userEntry['code_immo_id'] = value.toString();
              }
            }
          });
        }
      });
      prefs.setString("code_immo_id", userEntry['code_immo_id']);
      return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    readQr();
    return Center(
      child: scanMaterial(),
    );
  }

  Widget scanMaterial() {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.bottomCenter,
                    width: double.infinity,
                    color: const Color.fromRGBO(19, 62, 103, 1),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ManualEntry()));
                      },
                      icon: const Icon(Icons.handyman),
                      label: const Text("Entrer le code manuellement"),
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(19, 62, 103, 0.5),
                        minimumSize: const Size(double.infinity, 40),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: SizedBox(
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderColor: Colors.red,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: scanArea),
              ),
            ),
          ),
          SizedBox(
            height: 110,
            width: double.infinity,
            child: Column(
              children: [
                (result != null)
                    ? Container(
                        padding: const EdgeInsets.all(15),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Code Immo : ${result!.code}',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(15),
                        child: const TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Code Immo : ',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 10,
                  color: const Color.fromRGBO(59, 102, 153, 1),
                ),
                borderRadius: BorderRadius.circular(50)),
            child: IconButton(
              color: const Color.fromRGBO(59, 102, 153, 1),
              iconSize: 50,
              icon: const Icon(Icons.flashlight_on),
              onPressed: () async {
                await controller?.toggleFlash();
              },
            ),
          ),
        ],
      ),
    );
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
