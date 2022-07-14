import 'package:doctor_users/Functions/firebase_functions.dart';
import 'package:doctor_users/Screens/prescription_page.dart';
import 'package:doctor_users/models/pharmacy_models.dart';
import 'package:doctor_users/models/provider_pharma_drug.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicineSearch extends SearchDelegate {
  final String username;

  MedicineSearch({this.username = ""});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text("Search something"));
    }
    return FutureBuilder<Map<Pharmacy, List<Drug>>>(
      future: FirebaseApi.getPharmaAndMeds(query: query, username: username),
      builder: ((context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              if (snapshot.data!.isEmpty) {
                return const Center(child: Text("No result."));
              } else {
                Map<Pharmacy, List<Drug>>? pharmaDrug = snapshot.data;
                List<MapEntry<Pharmacy, List<Drug>>> listPharmaDrug =
                    pharmaDrug!.entries.toList();
                return ListView.builder(
                  itemCount: listPharmaDrug.length,
                  itemBuilder: ((context, index) {
                    return listPharmaDrug[index].value.isEmpty
                        ? Container()
                        : Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 20.0),
                            color: Colors.lightBlue.shade100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 10.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 10.0),
                                    child: Table(
                                      children: [
                                        TableRow(
                                          children: [
                                            const Text("pharmacy name:"),
                                            Text(
                                              listPharmaDrug[index].key.name,
                                              style: const TextStyle(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            const Text("Located at:"),
                                            Text(
                                              listPharmaDrug[index].key.loc,
                                              style: const TextStyle(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            const Text("Contact:"),
                                            Text(
                                              listPharmaDrug[index]
                                                  .key
                                                  .phone_number,
                                              style: const TextStyle(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  ...listPharmaDrug[index]
                                      .value
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              onTap: () {
                                                Provider.of<PharmaDrug>(context, listen: false)
                                                    .setPharmacyDrugEntry(listPharmaDrug[index]
                                                            .key, e);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: ((context) =>
                                                            PrescriptionPage(
                                                              drug:e,
                                                                pharmacy:
                                                                    listPharmaDrug[
                                                                            index]
                                                                        .key))));
                                              },
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              tileColor: Colors.amber.shade100,
                                              title: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      const Text("name:"),
                                                      Text(
                                                        e.name,
                                                        style: const TextStyle(
                                                          fontSize: 17.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      const Text(
                                                          "generic_name:"),
                                                      Text(
                                                        e.generic_name,
                                                        style: const TextStyle(
                                                          fontSize: 17.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              subtitle: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Text("price: "),
                                                          Text(
                                                            "${e.price} birr",
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Text(
                                                              "expires in: "),
                                                          Text(
                                                            e.expire_date,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ],
                              ),
                            ),
                          );
                  }),
                );
              }
            }
        }
      }),
    );
  }
}
