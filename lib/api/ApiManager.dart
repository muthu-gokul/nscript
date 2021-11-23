import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//BuildContext context
class ApiManager{


  Future< String> getApi(String url) async {
    try{

      final response = await http.get(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
      );

      if(response.statusCode==200){
        return response.body;
      }
      else if(response.statusCode==503 || response.statusCode==403 || response.statusCode==404 ||response.statusCode==422 || response.statusCode==0){
        return "null";
      }
      else{
        return "null";
      }

    }catch(e,t){

      return "null";
    }
  }
}
