import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
class Jsontester extends StatefulWidget {
  const Jsontester({super.key});

  @override
  State<Jsontester> createState() => _JsontesterState();
}

class _JsontesterState extends State<Jsontester> {
  late Future<Map<String,dynamic>>futureJsonData;
  Future<Map<String,dynamic>> fetchJsonData()async{
    final response=await Http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/10'));
    if(response.statusCode==200){
      final js=jsonDecode(response.body);
      print (js);
      return js;
    }else{
      throw Exception('Failed to load data');
    }
  }
  @override
  void initState(){
    super.initState();
    futureJsonData=fetchJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: Column(
          children:[
            ElevatedButton(
              onPressed:(){
                setState((){
                  futureJsonData=fetchJsonData();
                });
              },child:const Text("Read Json")
            ),
            Expanded(
                child:FutureBuilder<Map<String,dynamic>>(
                  future:futureJsonData,
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator());
                    }else if(snapshot.hasError){
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    }
                    else if(snapshot.hasData){
                      return Center(child:const Text("No data available"));
                    }else{
                      var item=snapshot.data!;
                      return ListView(
                        children: [
                          ListTile(
                            title: Text(item['title']),
                            subtitle: Text(item['body']),
                          )
                        ],
                      );
                    }
                  },
                ) )
          ]
        ),
      )
    );
  }

}

