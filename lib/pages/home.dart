import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/scheduler.dart';
String exCur = 'INR';
List searchTerms = [];
Map data = {};
List dataRaw = [];
String appTitle = "CoinEx";
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);
  @override
  State<home> createState() => _homeState();
}
class _homeState extends State<home> {
 changeData(image,coin,exCur,rate,lastUpdated,high24h,low24h,priceChange24h,marketCapRank ){
   setState(() {
     data = {'image':image,'coin': coin,'currency': exCur,'time': lastUpdated  ,'rate':rate,'high_24h':high24h,'low_24h':low24h,'price_change_24h':priceChange24h,'market_cap_rank':marketCapRank};
   });
 }
  @override
  Widget build(BuildContext context) {
   timeDilation = 2.0;
    data = data.isNotEmpty? data: ModalRoute.of(context)?.settings.arguments as Map;
    return Scaffold(
      backgroundColor: HexColor("06283D"),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: HexColor('06283D'),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Hero(
              tag: 'logo',
              child: CircleAvatar(
                maxRadius: 20,
                minRadius: 10,
                backgroundImage: AssetImage('assets/logo.png'),
              ),
            ),
            const SizedBox(width: 8,),
            Text(appTitle,style: GoogleFonts.righteous(
              textStyle: TextStyle(fontSize: 30,letterSpacing: 1.5,fontWeight: FontWeight.w700,color: HexColor('EEEEEE')),
            ),),
          ],
        )
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget> [
                  const SizedBox(height: 10,),
                  TextField(
                    onTap: () {
                      showSearch(context: context, delegate: CustomSearchDelegate(callBack:changeData));
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "search for coin",
                      suffixIcon: const Icon(Ionicons.search_outline,color: Colors.black,size: 30,),
                    ),
                    autocorrect: true,
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          width: MediaQuery.of(context).size.width * 0.95,
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                maxRadius: 70,
                                minRadius: 40,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                    data['image']),
                              ),
                              const SizedBox(width: 30,),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText.rich(
                                    TextSpan(text:data['coin'].toString().toUpperCase(),style: GoogleFonts.righteous()),
                                      presetFontSizes: const [30,20,15,17],
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5,),
                                    AutoSizeText(
                                      'exchange currency: ${data['currency'].toString().toUpperCase()}',
                                      presetFontSizes: const [26,20,17],
                                      maxLines: 1,
                                      style: const TextStyle(fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(height: 5,),
                                    AutoSizeText(
                                      'Rate:${data['rate'].toString()}',
                                      presetFontSizes: const [30,20,15,17],
                                      maxLines: 1,
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 5,),
                                    AutoSizeText(
                                      '(Last updated at : ${data['time']})',
                                      presetFontSizes: const [24,20,17,13],
                                      maxLines: 1,
                                      style: const TextStyle(fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AutoSizeText.rich(
                                    TextSpan(text: 'High 24 hour',style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.w400)),
                                    presetFontSizes: const [24,20,17],
                                    maxLines: 1,
                                  ),
                                  const Spacer(),
                                  AutoSizeText.rich(
                                    TextSpan(text: '${data['high_24h'].toStringAsFixed(5)}',style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.w300)),
                                    presetFontSizes: const [24,20,17],
                                    maxLines: 1,)
                                ],
                              ),
                              Divider(
                                thickness: 1.2,
                                height: 20,
                                color: HexColor("#999999"),
                              ),
                              Row(
                                children: [
                                  AutoSizeText.rich(
                                    TextSpan(text: 'Low 24 hour',style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.w400)),
                                    presetFontSizes: const [24,20,17],
                                    maxLines: 1,
                                  ),
                                  const Spacer(),
                                  AutoSizeText.rich(
                                    TextSpan(text: '${data['low_24h'].toStringAsFixed(5)}',style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.w300)),
                                    presetFontSizes: const [24,20,17],
                                    maxLines: 1,)
                                ],
                              ),
                              Divider(
                                thickness: 1.2,
                                height: 20,
                                color: HexColor("#999999"),
                              ),
                              Row(
                                children: [
                                  AutoSizeText.rich(
                                    TextSpan(text: 'Price change 24 hour',style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.w400)),
                                    presetFontSizes: const [20,17],
                                    maxLines: 1,
                                  ),
                                  const Spacer(),
                                  AutoSizeText.rich(
                                    TextSpan(text: '${data['price_change_24h'].toStringAsFixed(4)}',style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.w300)),
                                    presetFontSizes: const [22,20,17],
                                    maxLines: 1,)
                                ],
                              ),
                              Divider(
                                thickness: 1.2,
                                height: 20,
                                color: HexColor("#999999"),
                              ),
                              Row(
                                children: [
                                  AutoSizeText.rich(
                                    TextSpan(text: 'Market cap rank',style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.w400)),
                                    presetFontSizes: const [24,20,17],
                                    maxLines: 1,
                                  ),
                                  const Spacer(),
                                  AutoSizeText.rich(
                                    TextSpan(text: '${data['market_cap_rank'].toStringAsFixed(0)}',style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.w300)),
                                    presetFontSizes: const [24,20,17],
                                    maxLines: 1,)
                                ],
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
          ),
          ),
        ),
    );
  }
}


class CustomSearchDelegate extends SearchDelegate {
// first overwrite to
// clear the search text
final Function callBack;
CustomSearchDelegate({required this.callBack});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }
// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }
// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (int i=0;i<searchTerms.length;i++) {
      if (searchTerms[i].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(searchTerms[i]);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          leading: Image.network(dataRaw[index]['image']),
          title: Text(result),
          tileColor: Colors.red,
        );
      },
    );
  }
// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    void buildSearchList(){
      for (int i=0;i<searchTerms.length;i++) {
        if (searchTerms[i].toLowerCase().contains(query.toLowerCase())) {
          matchQuery.add(searchTerms[i]);
        }
      }
      matchQuery = matchQuery.toSet().toList();
    }
    buildSearchList();
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
            title: Text(result),
            onTap: (){
              dynamic image,rate,lastUpdated,high24h,low24h,priceChange24h,marketCapRank;
              for(int i =0;i<dataRaw.length;i++){
                if(result == dataRaw[i]['name']){
                  rate = CurrencyFormatter.format(dataRaw[i]['current_price'] ,CurrencyFormatterSettings.inr)?? 'Not available';
                  image = dataRaw[i]['image'] ?? 'https://openclipart.org/image/800px/301360';
                  if(dataRaw[i]['last_updated'] != Null){
                    DateTime now = DateTime.parse(dataRaw[i]['last_updated']!.toString());
                    lastUpdated = DateFormat.jm().format(now);
                  }
                  else{
                    lastUpdated = "Not available";
                  }
                  high24h = dataRaw[i]['high_24h'] ?? 'Not available';
                  low24h = dataRaw[i]['low_24h'] ?? 'Not available';
                  priceChange24h = dataRaw[i]['price_change_24h'] ?? 'Not available';
                  marketCapRank = dataRaw[i]['market_cap_rank'] ?? 'Not available';
                  callBack(image,result,exCur,rate,lastUpdated,high24h,low24h,priceChange24h,marketCapRank );
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  break;
                }
              }
              close(context, null);
            }
        );
      },
    );
  }
}
