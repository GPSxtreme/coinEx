import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:coin_price_tracker/pages/loading.dart';
class getCoinDataSpecific{
  String? id;
  String? exCur;
  dynamic rate;
  dynamic marketCap;
  dynamic day_vol;
  dynamic day_change;
  dynamic lastUpdated;
  bool dataFetched = false;
  //class constructor
  getCoinDataSpecific({required this.id , required this.exCur});
  Future<void> getDetails() async{
    try{
      dataFetched = false;
      String apiEndPoint = "https://api.coingecko.com/api/v3/simple/price?ids=$id&vs_currencies=$exCur&include_market_cap=true&include_24hr_vol=true&include_24hr_change=true&include_last_updated_at=true";
      Uri url = Uri.parse(apiEndPoint);
      var response = await http.get(url).timeout(const Duration(seconds: 5));
      if(response.statusCode == 200){
        Map data = jsonDecode(response.body);
        //get derails from obj
        rate = data[id][exCur] ?? 'Not available';
        lastUpdated = data[id]["last_updated_at"] ?? 'Not available';
        day_change = data[id]["${exCur!}_24h_change"] ?? 'Not available';
        day_vol = data[id]["${exCur!}_24h_vol"] ?? 'Not available';
        DateTime now = DateTime.parse(lastUpdated!.toString());
        lastUpdated = DateFormat.jm().format(now);
        dataFetched = true;
      }
      else{
        throw Exception('failed to fetch data');
      }
    }on TimeoutException catch(e){
      print('timeout fetching single coin');
      Future.delayed(const Duration(milliseconds: 2000), () {
        getDetails();
      });
    }
    on Error catch(e){
      print('Error:$e');
    }
   }
}