import 'package:flutter/material.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pluto_grid/pluto_grid.dart';

class GridStock extends StatefulWidget {
  const GridStock({Key? key}) : super(key: key);

  @override
  State<GridStock> createState() => _GridStockState();
}

class _GridStockState extends State<GridStock> {
  List<dynamic> history = [];
  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: "Date de l'opération",
      field: 'date',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Code Immo',
      field: 'immo',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Direction',
      field: 'direction',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Etat Matériel',
      field: 'state',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Email',
      field: 'email',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Adresse de stockage',
      field: 'storage',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Observation',
      field: 'observation',
      type: PlutoColumnType.text(),
    ),
  ];

  List<PlutoRow> rows = [];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: "Date de l'opération", fields: ['date']),
    PlutoColumnGroup(
        title: 'Information matérielle', fields: ['immo', 'direction']),
    PlutoColumnGroup(title: 'Status', children: [
      PlutoColumnGroup(title: 'Etat', fields: ['state'], expandedColumn: true),
      PlutoColumnGroup(title: 'Info .', fields: ['email', 'storage']),
      PlutoColumnGroup(title: 'Observation', fields: ['observation']),
    ]),
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager statemanager;

  _loadData() async {
    Provider provider = Provider();
    final source = await provider.getHistoryStockViewFromDB();
    if (source.isNotEmpty) {
      for (var element in source) {
        rows.add(
          PlutoRow(
            cells: {
              'date': PlutoCell(value: "${element["date"]}"),
              'immo': PlutoCell(value: "${element["CODE IMMO"]}"),
              'direction': PlutoCell(value: "${element["Direction"]}"),
              'state': PlutoCell(value: "${element["Etat Matériel"]}"),
              'email': PlutoCell(value: "${element["email"]}"),
              'storage': PlutoCell(value: "${element["Adresse de stockage"]}"),
              'observation': PlutoCell(value: "${element["observation"]}"),
            },
          ),
        );
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: const Text("Historique stock")),
      endDrawer: fDrawer(context),
      body: Center(child: loadData()),
    );
  }

  Widget loadData() {
    return FutureBuilder(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return historyStock();
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget historyStock() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: PlutoGrid(
        mode: PlutoGridMode.normal,
        columns: columns,
        rows: rows,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          statemanager = event.stateManager;
        },
        onChanged: (PlutoGridOnChangedEvent event) {},
        configuration: const PlutoGridConfiguration(
          enableColumnBorder: true,
        ),
      ),
    );
  }
}
