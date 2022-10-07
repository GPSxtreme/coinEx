// ignore_for_file: use_build_context_synchronously, camel_case_types
import 'package:coin_price_tracker/services/getAllCoins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:coin_price_tracker/pages/home.dart';
import 'package:intl/intl.dart';
import 'package:currency_formatter/currency_formatter.dart';


String message = "This process may take a minute...";
class loading extends StatefulWidget {
  const loading({Key? key}) : super(key: key);
  @override
  State<loading> createState() => _loadingState();
}

class _loadingState extends State<loading> {
  void setupCoinDetails(int i)async{
    getAllCoins instance = getAllCoins(exCur: exCur);
    dataRaw = (await instance.getDetails(searchTerms))!;
    DateTime now = DateTime.parse(instance.dataBulk[i]['last_updated']!.toString());
    String lastUpdated = DateFormat.jm().format(now);
    if(instance.dataFetched){
      Future.delayed(const Duration(seconds: 5),(){
        Navigator.pushReplacementNamed(context,'/home',arguments: {'coin': instance.dataBulk[i]['name'],'currency': instance.exCur,'time': lastUpdated ,'rate':CurrencyFormatter.format(instance.dataBulk[i]['current_price'] ,CurrencyFormatterSettings.inr),'high_24h':instance.dataBulk[i]['high_24h'],'low_24h':instance.dataBulk[i]['low_24h'],'market_cap_rank':instance.dataBulk[i]['market_cap_rank'],'price_change_24h':instance.dataBulk[i]['price_change_24h'],'image':instance.dataBulk[i]['image']});
      });
    }
    else{
      Future.delayed(const Duration(seconds: 2),() async {
        setupCoinDetails(1);
      });
    }
  }
  @override
  void initState(){
    super.initState();
    setupCoinDetails(1);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('06283D'),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Hero(
              tag: 'logo',
              child: CircleAvatar(
                maxRadius: 100,
                minRadius: 80,
                backgroundImage: AssetImage('assets/logo.png'),
              ),
            ),
            const SizedBox(height: 20,),
            Text(appTitle,style: GoogleFonts.righteous(
              textStyle: TextStyle(fontSize: 50,letterSpacing: 1.5,fontWeight: FontWeight.w700,color: HexColor('ffffff')),
            ),),
            const SizedBox(height: 20,),
            const SpinKitPouringHourGlass(
              color:Colors.amber,
              size: 70.0,
            ),
            const SizedBox(height: 20,),
            Text(message,style: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w300),),
          ],
        )
      )
    );
  }
}
