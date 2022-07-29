import 'package:flutter/material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';

class HistoryStockViewList extends StatefulWidget {
  const HistoryStockViewList({Key? key}) : super(key: key);

  @override
  State<HistoryStockViewList> createState() => _HistoryStockViewListState();
}

class _HistoryStockViewListState extends State<HistoryStockViewList> {
  Provider provider = Provider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text("Genre List"),
      ),
      body: FutureBuilder(
        future: provider.getHistoryStockViewFromDB(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Map<String, dynamic>>? user =
                snapshot.data as List<Map<String, dynamic>>?;
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

  Widget _buildListView(List<Map<String, dynamic>> immos) {
    return immos.isNotEmpty
        ? ListView.builder(
            itemCount: immos.length,
            itemBuilder: (context, index) {
              final immo = immos[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(immo["CODE IMMO"].toString() +
                      " " +
                      immo["Direction"].toString()),
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
