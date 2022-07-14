import 'package:doctor_users/Functions/firebase_functions.dart';
import 'package:flutter/material.dart';

class LabResultDetail extends StatelessWidget {
  const LabResultDetail(
      {Key? key,
      required this.usernameUuid,
      required this.singleUuid,
      required this.username})
      : super(key: key);
  final List<Map<String, dynamic>> usernameUuid;
  final String singleUuid;
  final String username;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> result = usernameUuid
        .where((element) => element.values.first == singleUuid)
        .toList();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Lab Order Results"),
        ),
        body: FutureBuilder<String>(
          future: FirebaseApi.fetchExactLabResults(uuidUsername: result.first),
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
                String? result = snapshot.data;
                return Column(
                  children: [
                    const Spacer(),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 14.5),
                      color: Colors.lightBlue.shade100,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 15.4),
                        child: Column(
                          children: [
                            Text(
                              username,
                              style: const TextStyle(
                                fontSize: 19.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Divider(),
                            const SizedBox(height: 10.0),
                            Text(result ?? "no result please try again")
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                );
            }
          }),
        ),
      ),
    );
  }
}
