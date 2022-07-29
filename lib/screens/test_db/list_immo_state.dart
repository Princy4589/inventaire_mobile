import 'package:flutter/material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/models/immo_state.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';

class ImmostateList extends StatefulWidget {
  const ImmostateList({Key? key}) : super(key: key);

  @override
  State<ImmostateList> createState() => _ImmostateListState();
}

class _ImmostateListState extends State<ImmostateList> {
  Provider provider = Provider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text("Genre List"),
      ),
      body: FutureBuilder(
        future: provider.getStateFromDB(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<ImmoState>? user = snapshot.data as List<ImmoState>?;
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

  Widget _buildListView(List<ImmoState> immos) {
    return immos.isNotEmpty
        ? ListView.builder(
            itemCount: immos.length,
            itemBuilder: (context, index) {
              ImmoState immo = immos[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(immo.immoStateId.toString() +
                      " " +
                      immo.state +
                      " codeimmoId : " +
                      immo.codeImmoId.toString()),
                  dense: true,
                  onTap: () {},
                ),
              );
            },
          )
        : const Center(
            child: SizedBox(child: Text("Aucun code immo n'a été trouvé")));
  }
}
