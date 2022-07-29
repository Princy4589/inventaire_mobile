import 'package:flutter/material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/models/code_immo.dart';
import 'package:pgi_mobile/services/offline/user_service_offline.dart';

class ImmoCode extends StatefulWidget {
  const ImmoCode({Key? key}) : super(key: key);

  @override
  State<ImmoCode> createState() => _ImmoCodeState();
}

class _ImmoCodeState extends State<ImmoCode> {
  OfflineService offline = OfflineService();
  TextEditingController editingController = TextEditingController();
  List<CodeImmo>? user;
  List<CodeImmo>? imo;

  void filterSearchResults(String query) async {
    List<CodeImmo> dummySearchList = [];
    List<CodeImmo> dummyListData = [];
    dummySearchList.addAll(user!);
    if (query.isNotEmpty) {
      var data = dummySearchList
          .where(((element) => element.codeImmoCode.contains(query)));
      if (data.isNotEmpty) {
      } else {}

      setState(() {
        imo?.clear();
        imo?.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        imo?.clear();
        imo?.addAll(imo!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text("immo_code"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: offline.fetchImmo(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        "Something wrong with message: ${snapshot.error.toString()}"),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  imo = snapshot.data as List<CodeImmo>?;
                  user = imo;
                  return _buildListView(imo!);
                  // return _buildListView(persons);
                } else {
                  return Center(
                    child: Container(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<CodeImmo> immos) {
    return immos.isNotEmpty
        ? ListView.builder(
            itemCount: immos.length,
            itemBuilder: (context, index) {
              CodeImmo immo = immos[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(immo.codeImmoCode + " " + immo.codeName),
                  subtitle: Text("immo date: " +
                      immo.dateAcquis +
                      "\nname : " +
                      immo.name),
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
