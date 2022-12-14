import 'package:flutter/material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/models/person.dart';

import 'package:pgi_mobile/services/offline/database_helper.dart';

class PersonList extends StatefulWidget {
  const PersonList({Key? key}) : super(key: key);

  @override
  State<PersonList> createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  Provider provider = Provider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text("Person List"),
      ),
      body: FutureBuilder(
        future: provider.getPersonFromDB(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Person>? user = snapshot.data as List<Person>?;
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

  Widget _buildListView(List<Person> immos) {
    return immos.isNotEmpty
        ? ListView.builder(
            itemCount: immos.length,
            itemBuilder: (context, index) {
              Person immo = immos[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(immo.firstName + " " + immo.lastName.toString()),
                  subtitle: Text("direction Id : " + immo.address),
                  dense: true,
                  onTap: () {},
                ),
              );
            },
          )
        : const Center(
            child: SizedBox(
              child: Text("Aucun code immo n'a été trouvé"),
            ),
          );
  }
}
