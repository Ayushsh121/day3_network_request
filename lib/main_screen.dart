import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model_class.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<ModelClass> apiList = [];
  Future apiCall() async{
    var url = "https://fakestoreapi.com/products";
    final response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    if(response.statusCode == 200){
      for(Map<String , dynamic> i in jsonData){
        apiList.add(ModelClass.fromJson(i));
      }
      return apiList;
    }else{
      try{
        apiCall();
    }catch(e){
        print(e.toString());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Network Request",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: FutureBuilder(
        future: apiCall(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return ListView.builder(
            itemCount: apiList.length,
              itemBuilder: (context , index){
                return Container(
                  child: Card(
                    elevation: 10,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(apiList[index].image.toString()),
                      ),
                      title: Text(apiList[index].title.toString()),
                      trailing: Text('\$ : ${apiList[index].price.toString()}',
                        style: TextStyle(color: Colors.indigo , fontWeight: FontWeight.bold,fontSize: 15),),
                    ),
                  ),
                );
          });
        },),
    );
  }
}
