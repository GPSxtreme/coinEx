import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:coin_price_tracker/pages/loading.dart';
class getAllCoins{
  String? exCur;
  bool dataFetched = false;
  List dataBulk = [];
  //class constructor
  getAllCoins({required this.exCur});
  Future<List?> getDetails (List search) async{
    try{
      dataFetched = false;
      // String apiEndPoint = "https://rest.coinapi.io/v1/assets/?apikey=$apiKey2";
      String apiEndPoint = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=$exCur";
      Uri url = Uri.parse(apiEndPoint);
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      if(response.statusCode == 200){
        dataBulk= await jsonDecode(response.body) ;
        for(int i=0;i<dataBulk.length;i++){
          search.add(dataBulk[i]['name']);
        }
        dataFetched = true;
        return dataBulk;
      }
      else{
        throw Exception('Failed to fetch coins');
      }
    }on TimeoutException catch(e){
      print('timeout fetching coins bulk');
      Future.delayed(const Duration(milliseconds: 2000), () {
        getDetails(search);
      });
    }
    on Error catch(e){
      print('Error:$e');
    }
    return null;
  }

}