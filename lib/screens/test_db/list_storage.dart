import 'package:flutter/material.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pgi_mobile/models/storage_address.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';

class StorageAddressList extends StatefulWidget {
  const StorageAddressList({Key? key}) : super(key: key);

  @override
  State<StorageAddressList> createState() => _StorageAddressListState();
}

class _StorageAddressListState extends State<StorageAddressList> {
  Provider provider = Provider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text("StorageAddress List"),
      ),
      body: FutureBuilder(
        future: provider.getStorageFromDB(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<StorageAddress>? user = snapshot.data as List<StorageAddress>?;
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

  Widget _buildListView(List<StorageAddress> immos) {
    return immos.isNotEmpty
        ? ListView.builder(
            itemCount: immos.length,
            itemBuilder: (context, index) {
              StorageAddress immo = immos[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(immo.storageAddress.toString() +
                      " " +
                      immo.seatId.toString()),
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
