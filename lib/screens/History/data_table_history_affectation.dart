import 'package:flutter/material.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';
import 'package:pgi_mobile/utils/components.dart';
import 'package:pluto_grid/pluto_grid.dart';

class GridAffectation extends StatefulWidget {
  const GridAffectation({Key? key}) : super(key: key);

  @override
  State<GridAffectation> createState() => _GridAffectationState();
}

class _GridAffectationState extends State<GridAffectation> {
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
      title: 'Personne affectée',
      field: 'person',
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
        title: 'Information matériel', fields: ['immo', 'direction']),
    PlutoColumnGroup(title: 'Status', children: [
      PlutoColumnGroup(title: 'Etat', fields: ['state'], expandedColumn: true),
      PlutoColumnGroup(title: 'Infos personnels', fields: ['email', 'person']),
      PlutoColumnGroup(title: 'Observation', fields: ['observation']),
    ]),
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  _loadData() async {
    Provider provider = Provider();
    final source = await provider.getHistoryAffectationViewFromDB();
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
              'person': PlutoCell(value: "${element["person"]}"),
              'observation': PlutoCell(value: "${element["observation"]}"),
            },
          ),
        );
      }
    }
    return rows;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(title: const Text("Historique Affectation")),
      endDrawer: fDrawer(context),
      body: Center(child: loadRows()),
    );
  }

  Widget tableAffectation() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: PlutoGrid(
        mode: PlutoGridMode.normal,
        columns: columns,
        rows: rows,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
        },
        onChanged: (PlutoGridOnChangedEvent event) {},
        configuration: const PlutoGridConfiguration(
          enableColumnBorder: true,
        ),
      ),
    );
  }

  Widget loadRows() {
    return FutureBuilder(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return tableAffectation();
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
