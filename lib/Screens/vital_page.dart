import 'package:doctor_users/Functions/firebase_functions.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';

class VitalPage extends StatelessWidget {
  const VitalPage({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vital Informations"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
            child: FutureBuilder<Map<List<String>, List<String>>>(
              future: FirebaseApi.getVitalinfo(email),
              builder: ((context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    Map<List<String>, List<String>>? stringValues =
                        snapshot.data;
                    List<double> doubleValues = [];
                    List<double> oxygenLevel = [];
                    for (String dataString
                        in stringValues!.entries.first.key) {
                      doubleValues.add(double.parse(dataString));
                    }
                    for (String dataString
                        in stringValues.entries.first.value) {
                      oxygenLevel.add(double.parse(dataString));
                    }
                    List<Feature> features = [
                      Feature(
                        data: doubleValues,
                        title: "Heart beat",
                        color: Colors.blue,
                      ),
                      Feature(
                        data: oxygenLevel,
                        title: "Blood Oxygen level",
                        color: Colors.red,
                      ),
                    ];
                    return Column(
                      children: [
                        LineGraph(
                          features: features,
                          labelX: List.generate(
                              doubleValues.length, (index) => "$index"),
                          labelY: List.generate(doubleValues.length,
                              (index) => "${index * 5.floorToDouble()}"),
                          size: const Size(400.0, 500.0),
                          showDescription: true,
                          graphOpacity: 0,
                          verticalFeatureDirection: true,
                          descriptionHeight: 130,
                        ),
                        SizedBox(
                          height: 70.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: [
                              const Text("Heartbeat Readings:"),
                              Wrap(
                                children: doubleValues
                                    .map((e) => Chip(
                                          backgroundColor:
                                              doubleValues[0] == e
                                                  ? Colors.red
                                                  : null,
                                          label: Text("$e "),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          height: 70.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: [
                              const Text("Oxygen Level Readings:"),
                              Wrap(
                                children: oxygenLevel.map((e) {
                                  return Chip(
                                    label: Text("$e "),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
