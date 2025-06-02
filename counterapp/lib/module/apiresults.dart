import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CardBuild extends StatefulWidget {
  const CardBuild({super.key});

  @override
  State<CardBuild> createState() => _CardBuildState();
}

class _CardBuildState extends State<CardBuild> {
  List? listResponse;

  Future apicall() async {
    http.Response response;

    final apiurl = dotenv.env['API_URL'];
    if (apiurl == null) {
      throw Exception("API_URL not found in .env file");
    }

    response = await http.get(Uri.parse(apiurl));
    if (response.statusCode == 200) {
      setState(() {
        final mapResponse = json.decode(response.body);
        listResponse = mapResponse!['data'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    apicall();
  }

  @override
  Widget build(BuildContext context) {
    return listResponse == null
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: listResponse == null ? 0 : listResponse?.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: listResponse == null
                              ? const Text("Data is loading")
                              : Text(
                                  '${listResponse![index]!['first_name']} ${listResponse![index]!['last_name']}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Image.network(
                            listResponse![index]!['avatar'],
                          ),
                        ),
                        const SizedBox(height: 10),
                        listResponse == null
                            ? const Text("Data is loading")
                            : Center(
                                child: Text(
                                  'email: ${listResponse![index]!['email']}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
