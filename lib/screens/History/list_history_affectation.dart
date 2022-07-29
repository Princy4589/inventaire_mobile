import 'package:flutter/material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/models/history_affectation.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';

class HistoryaffectationList extends StatefulWidget {
  const HistoryaffectationList({Key? key}) : super(key: key);

  @override
  State<HistoryaffectationList> createState() => _HistoryaffectationListState();
}

class _HistoryaffectationListState extends State<HistoryaffectationList> {
  Provider provider = Provider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text("Genre List"),
      ),
      body: FutureBuilder(
        future: provider.getHistoryAffectationFromDB(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Historyaffectation>? user =
                snapshot.data as List<Historyaffectation>?;
            return _buildListView(user!);
            // return _buildListView(persons);
          } else {
            return Center(
              child: Container(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<Historyaffectation> immos) {
    return immos.isNotEmpty
        ? ListView.builder(
            itemCount: immos.length,
            itemBuilder: (context, index) {
              Historyaffectation immo = immos[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(immo.historyId.toString() +
                      " " +
                      immo.timeOfOperation.toString() +
                      "immo state id :" +
                      immo.immoStateId.toString()),
                  dense: true,
                  onTap: () {},
                ),
              );
            },
          )
        : const Center(
            child: SizedBox(child: Text("Rien n'a été encore commencé")));
  }
}
