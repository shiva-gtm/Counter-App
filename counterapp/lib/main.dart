import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List? listResponse;
  Future apicall() async {
    http.Response response;
    response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    if (response.statusCode == 200) {
      setState(() {
        final mapResponse = json.decode(response.body);
        listResponse = mapResponse!['data'];
      });
    }
  }

  @override
  void initState() {
    apicall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 165, 166, 165),
      appBar: AppBar(
        title: const Text('API Demo'),
        centerTitle: true,
      ),
      body: listResponse == null
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
            ),
    );
  }
}
