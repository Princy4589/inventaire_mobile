import 'package:flutter/material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/models/history_stock.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';

class HistoryStockList extends StatefulWidget {
  const HistoryStockList({Key? key}) : super(key: key);

  @override
  State<HistoryStockList> createState() => _HistoryStockListState();
}

class _HistoryStockListState extends State<HistoryStockList> {
  Provider provider = Provider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text("Genre List"),
      ),
      body: FutureBuilder(
        future: provider.getHistoryStockFromDB(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Historystock>? user = snapshot.data as List<Historystock>?;
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

  Widget _buildListView(List<Historystock> immos) {
    return immos.isNotEmpty
        ? ListView.builder(
            itemCount: immos.length,
            itemBuilder: (context, index) {
              Historystock immo = immos[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(immo.storageId.toString() +
                      " " +
                      immo.timeOfOperation.toString()),
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
