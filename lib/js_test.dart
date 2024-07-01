import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Js_Test extends StatefulWidget {
  const Js_Test({super.key});

  @override
  State<Js_Test> createState() => _Js_TestState();
}

class _Js_TestState extends State<Js_Test> {
  late Future<List<dynamic>> futureJsonData;

  Future<List<dynamic>> fetchJsonData() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      final js = jsonDecode(response.body);
      print(js);
      return js;
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  void initState() {
    super.initState();
    futureJsonData = fetchJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Json Data Read"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                futureJsonData = fetchJsonData();
              });
            },
            child: const Text("Read"),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: futureJsonData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No data available'),
                  );
                } else {
                  var items = snapshot.data!;
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      return Card(
                        child: ListTile(
                          title: Text(item['title']),
                          subtitle: Text(item["body"]),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
