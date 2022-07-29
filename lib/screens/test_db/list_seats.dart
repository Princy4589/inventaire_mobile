import 'package:flutter/material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/models/seats.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';

class SeatsList extends StatefulWidget {
  const SeatsList({Key? key}) : super(key: key);

  @override
  State<SeatsList> createState() => _SeatsListState();
}

class _SeatsListState extends State<SeatsList> {
  Provider provider = Provider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text("Seats List"),
      ),
      body: FutureBuilder(
        future: provider.getSeatsFromDB(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Seat>? user = snapshot.data as List<Seat>?;
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

  Widget _buildListView(List<Seat> immos) {
    return immos.isNotEmpty
        ? ListView.builder(
            itemCount: immos.length,
            itemBuilder: (context, index) {
              Seat immo = immos[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(immo.seatName + " " + immo.seatId.toString()),
                  subtitle:
                      Text("direction Id : " + immo.directionId.toString()),
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
