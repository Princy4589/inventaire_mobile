import 'package:flutter/material.dart';
import 'package:pgi_mobile/screens/Scan/new_summary.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Observation extends StatelessWidget {
  const Observation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: MyAppbar(
        title: const Text("Observation"),
      ),
      body: const ObservationWidget(),
      endDrawer: fDrawer(context),
    );
  }
}

class ObservationWidget extends StatefulWidget {
  const ObservationWidget({Key? key}) : super(key: key);

  @override
  State<ObservationWidget> createState() => _ObservationWidget();
}

class _ObservationWidget extends State<ObservationWidget> {
  TextEditingController text = TextEditingController();

  Future saveObservation(observation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("observation", observation);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        height: 400,
        child: SizedBox(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                  child: const Text(
                    "Observation",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: TextField(
                    controller: text,
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(19, 62, 103, 1),
                        minimumSize: const Size.fromHeight(50),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(0),
                                bottom: Radius.circular(30)))),
                    onPressed: () async {
                      await saveObservation(text.text).whenComplete(() =>
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Summary())));
                    },
                    child: const Text("Suivant"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
