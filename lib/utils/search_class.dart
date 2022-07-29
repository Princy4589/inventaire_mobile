import 'package:flutter/material.dart';
import 'package:pgi_mobile/models/code_immo.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';

class CustomSearchDelegate extends SearchDelegate {
  // Demo list to show querying
  List<CodeImmo> search = [];

  getListImmo() async {
    Provider provider = Provider();
    final list = await provider.getImmoFromDB();
    search = list;
  }

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    getListImmo();
    List<String> matchQuery = [];
    for (var fruit in search) {
      if (fruit.codeImmoCode.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit.codeImmoCode);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            close(context, result);
          },
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    getListImmo();
    List<String> matchQuery = [];
    for (var fruit in search) {
      if (fruit.codeImmoCode.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit.codeImmoCode);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            close(context, result);
          },
        );
      },
    );
  }
}
