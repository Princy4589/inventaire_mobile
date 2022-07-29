import 'package:flutter/material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/models/traceability_service.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';

class TraceabilityServiceList extends StatefulWidget {
  const TraceabilityServiceList({Key? key}) : super(key: key);

  @override
  State<TraceabilityServiceList> createState() =>
      _TraceabilityServiceListState();
}

class _TraceabilityServiceListState extends State<TraceabilityServiceList> {
  Provider provider = Provider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text("TraceabilityService List"),
      ),
      body: FutureBuilder(
        future: provider.getTraceabilityServiceFromDB(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<TraceabilityService>? user =
                snapshot.data as List<TraceabilityService>?;
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

  Widget _buildListView(List<TraceabilityService> immos) {
    return immos.isNotEmpty
        ? ListView.builder(
            itemCount: immos.length,
            itemBuilder: (context, index) {
              TraceabilityService immo = immos[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(immo.serviceId.toString() +
                      " User Id" +
                      immo.userId.toString()),
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
