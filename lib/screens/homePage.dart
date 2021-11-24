// ignore: file_names
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nscript/api/ApiManager.dart';
import 'package:nscript/constants/constants.dart';
import 'package:nscript/constants/size.dart';
import 'package:nscript/model/dataModel.dart';
import 'package:nscript/widgets/circle.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  List<String> tabList=["INFO","LADDER","F&O","TECHNICAL","FUNDAMENTAL"];
  List<String> tabList2=["Buy/Sell","LTP","OI","Greeks",];
  late TabController tabController,tabController2;
  late double width1,width2;
  //double width2=25;

  String? _chosenValue;
  String? selectedDate;

  dynamic? currentStrike;
  List<dynamic> expiry=[];
  List<Data> data=[];
  List<Data> filterData=[];

  double totalCallOi=0.0;
  double totalPutOi=0.0;

  getData(){
    ApiManager().getApi("http://nscript.net/flutter_app/option_chain.json").then((value){
      //log("$value");
      if(value!="null"){
        var parsed=json.decode(value);
        List<dynamic> tempData=parsed['data'] as List;
        setState(() {
          currentStrike=parsed['current_strike'];
          expiry=parsed['expiry'];
          filterData=tempData.map((e) => Data.fromJson(e)).toList();
          data=filterData;
          selectedDate=expiry[0];
          filter();
        });
      }

    });
  }

  filter(){
    totalCallOi=0.0;
    totalPutOi=0.0;
    setState(() {
      data=filterData.where((element) => element.expirydate==selectedDate).toList();
      data.forEach((element) {
        totalCallOi+=element.callOi;
        totalPutOi+=element.putOi;
      });
    });

  }

  
  @override
  void initState() {
    tabController=new TabController(length: tabList.length, vsync: this,initialIndex: 2);
    tabController2=new TabController(length: tabList2.length, vsync: this);
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    width1=SizeConfig.screenWidth!-20;
    width2=width1*0.3;
    return SafeArea(
      child:Scaffold(
        body: Container(
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("AXISBANK21JANFUT",style: ts16(Colors.green),),
              SizedBox(height: 5,),
              RichText(
                text: TextSpan(
                  text: '+${currentStrike??0} ',
                  style: ts16(Colors.red),
                  children: <TextSpan>[
                    TextSpan(text: '-15.98 (12.5%)', style: ts16(Colors.grey,fontSize: 15)),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                    //  getData();
                    },
                    child: Container(
                      height: 32,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor1)
                      ),
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("NSE",style: ts16(Colors.black,fontFamily: 'RM',fontSize: 18),),
                          Circle(hei: 17, color: blue),

                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Circle(
                    hei: 45,
                    borderColor: borderColor1,
                    color: Color(0xffF5F5F5),
                    margin: EdgeInsets.only(right: 10),
                    widget: Center(
                      child: Icon(Icons.show_chart,color: Colors.black,),
                    ),
                  ),
                  Circle(
                    hei: 45,
                    color: Color(0xff54B988),
                    margin: EdgeInsets.only(right: 10),
                    widget: Center(child: Text("Buy",style: ts14(Colors.white),)),
                  ),
                  Circle(
                    hei: 45,
                    color: Color(0xffEB4E5D),
                    widget: Center(child: Text("Sell",style: ts14(Colors.white),)),
                  ),
                ],
              ),
              SizedBox(height: 12,),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: borderColor2),
                    bottom: BorderSide(color: borderColor2),
                  )
                ),
                width: SizeConfig.screenWidth,
                child: TabBar(
                 controller: tabController,
                  isScrollable: true,
                  unselectedLabelColor: textColor1,
                  labelColor: textColor2,
                  indicator: BoxDecoration(
                      color: blue,
                   borderRadius: BorderRadius.circular(20),
                  ),
                  indicatorPadding: EdgeInsets.only(top: 48,),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    for(int i=0;i<tabList.length;i++)
                      Tab(
                        child: Text(tabList[i],
                          style: TextStyle(fontFamily: 'RR',fontSize: 15),
                        ),
                      ),

                  ],
                ),
              ),

              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    Container(
                      color: Colors.white,
                    ),
                    Container(
                      color: Colors.white,
                    ),
                    Container(
                     child: Column(
                       children: [
                         SizedBox(height: 10,),
                         Row(
                           children: [
                             Container(
                               width:SizeConfig.screenWidth!*0.45,
                               height: 40,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(50),
                                 border: Border.all(color: borderColor1)
                               ),

                               child: DropdownButton<String>(
                                 isExpanded: true,
                                 value: _chosenValue,
                                 underline: Container(),
                                 //elevation: 5,
                                 style: TextStyle(color: Colors.white),
                                 iconEnabledColor:Colors.grey,
                                 iconSize: 30,
                                 items: <String>[
                                   'put_oi',
                                   'put_oi_change',
                                   'call_oi',
                                   'call_oi_change',
                                 ].map<DropdownMenuItem<String>>((String value) {
                                   return DropdownMenuItem<String>(
                                     value: value,
                                     child: Container(
                                         alignment: Alignment.center,
                                         child: Text(value,style:TextStyle(color:Colors.black),)),
                                   );
                                 }).toList(),
                                 alignment: AlignmentDirectional.center,

                                 hint:Container(
                                   alignment: Alignment.center,
                                   child: Text(
                                     "OPTIONS",
                                     style: TextStyle(
                                         color: Colors.black,
                                         fontSize: 14,
                                         fontWeight: FontWeight.w500),
                                   ),
                                 ),
                                 onChanged: (String? value) {
                                   setState(() {
                                     _chosenValue = value;
                                   });
                                 },
                               ),
                             ),
                             Spacer(),
                             Container(
                               width:SizeConfig.screenWidth!*0.45,
                               height: 40,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(50),
                                 border: Border.all(color: borderColor1)
                               ),

                               child: DropdownButton<dynamic>(
                                 isExpanded: true,
                                 value: selectedDate,
                                 underline: Container(),
                                 //elevation: 5,
                                 style: TextStyle(color: Colors.white),
                                 iconEnabledColor:Colors.grey,
                                 iconSize: 30,
                                 items: expiry.map<DropdownMenuItem<dynamic>>((dynamic value) {
                                   return DropdownMenuItem<dynamic>(
                                     value: value,
                                     child: Container(
                                         alignment: Alignment.center,
                                         child: Text(value,style:TextStyle(color:Colors.black),)),
                                   );
                                 }).toList(),
                                 alignment: AlignmentDirectional.center,

                                 hint:Container(
                                   alignment: Alignment.center,
                                   child: Text(
                                     "Select date",
                                     style: TextStyle(
                                         color: Colors.black,
                                         fontSize: 14,
                                         fontWeight: FontWeight.w500),
                                   ),
                                 ),
                                 onChanged: ( value) {
                                   setState(() {
                                     selectedDate = value;
                                   });
                                   filter();
                                 },
                               ),
                             ),
                           ],
                         ),
                         SizedBox(height: 10,),
                         Container(
                           height: 40,
                           decoration: BoxDecoration(
                               border: Border.all(color: borderColor1),
                             borderRadius: BorderRadius.circular(50)
                           ),
                           width: SizeConfig.screenWidth,
                           child: TabBar(
                             controller: tabController2,
                             isScrollable: true,
                             unselectedLabelColor: textColor2,
                             labelColor: Colors.white,
                             indicator: BoxDecoration(
                               color: blue,
                               borderRadius: BorderRadius.circular(50),
                             ),
                             indicatorSize: TabBarIndicatorSize.tab,

                             tabs: [
                                 Container(
                                   width:width1*0.17,
                                   child: Text("${tabList2[0]}",
                                     style: TextStyle(fontFamily: 'RR',fontSize: 15),
                                   ),
                                 ),
                               Container(
                                 width:width1*0.15,
                                 alignment: Alignment.center,
                                 child: Text("${tabList2[1]}",
                                   style: TextStyle(fontFamily: 'RR',fontSize: 15),
                                 ),
                               ),
                               Container(
                                 width:width1*0.15,
                                 alignment: Alignment.center,
                                 child: Text("${tabList2[2]}",
                                   style: TextStyle(fontFamily: 'RR',fontSize: 15),
                                 ),
                               ),
                               Container(
                                 width:width1*0.15,
                                 alignment: Alignment.center,
                                 child: Text("${tabList2[3]}",
                                   style: TextStyle(fontFamily: 'RR',fontSize: 15),
                                 ),
                               ),
                             ],
                           ),
                         ),
                         SizedBox(height: 10,),
                         Container(
                           height: 40,
                           width: width1,
                           decoration: BoxDecoration(
                             border: Border(
                               top: BorderSide(color: borderColor1.withOpacity(0.5)),
                               bottom: BorderSide(color: borderColor1.withOpacity(0.5)),
                             )
                           ),
                           child: Row(
                             children: [
                               Container(
                                 width: width1*0.3,
                                 alignment: Alignment.center,
                                 child: Text("Call OI(Chg %)",style: ts14(textColor1),),
                               ),
                               Container(
                                 width: width1*0.2,
                                 alignment: Alignment.center,
                                 child: Text("STRIKE",style: ts14(textColor2,fontFamily: 'RM'),),
                               ),
                               Container(
                                 width: width1*0.2,
                                 alignment: Alignment.center,
                                 child: Text("IV",style: ts14(textColor2,fontFamily: 'RM'),),
                               ),
                               Container(
                                 width: width1*0.3,
                                 alignment: Alignment.center,
                                 child: Text("Put OI(Chg %)",style: ts14(textColor1),),
                               ),
                             ],
                           ),
                         ),
                         Expanded(
                           child: ListView.builder(
                             itemCount: data.length,
                             itemBuilder: (ctx,i){
                               return Container(
                                 height: 40,
                                 width: width1,
                                 decoration: BoxDecoration(
                                   border: Border(bottom: BorderSide(color: borderColor1.withOpacity(0.3))),
                                   color: data[i].strike==currentStrike?Color(0xffFEEE96):Colors.white
                                 ),
                                 child: Stack(
                                   children: [
                                     Row(
                                       children: [
                                         Container(
                                           width: width1*0.3,
                                           alignment: Alignment.center,
                                          color: data[i].strike<=currentStrike?Color(0xffFEEE96):Colors.white,
                                           child: Stack(
                                             children: [
                                               Container(
                                                 width:width2,
                                                 alignment: Alignment.centerLeft,
                                                 child: Container(
                                                   height: 40,
                                                   width: width2*(double.parse(((data[i].callOi/totalCallOi)*100).toStringAsFixed(2))/100),
                                                   decoration: BoxDecoration(
                                                       color: Color(0xffFBC77C),
                                                       borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                                                   ),
                                                 ),
                                               ),
                                               Align(
                                                 alignment: Alignment.center,
                                                 child: Container(
                                                   width: width1*0.3,
                                                   height: 17,
                                                   alignment: Alignment.center,
                                                   child:FittedBox(
                                                     child: Row(
                                                       mainAxisAlignment: MainAxisAlignment.start,
                                                       children: [
                                                         Text('${data[i].callOi} ',style: ts14(textColor2),),
                                                         Text(' ${data[i].callOiChange} ',style: ts16(data[i].callOiChange>0?Color(0xff8CC1A8):Colors.red,fontSize: 15),),
                                                       ],
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                             ],
                                           ),
                                         //  child: Text("${data[i].callOi}",style: ts14(textColor1),),
                                         ),
                                         Container(
                                           width: width1*0.2,
                                           alignment: Alignment.center,
                                           child: Text("${data[i].strike}",style: ts14(textColor2,fontFamily: 'RM'),),
                                         ),
                                         Container(
                                           width: width1*0.2,
                                           alignment: Alignment.center,
                                           child: Text("${data[i].iv}",style: ts14(textColor2,fontFamily: 'RM'),),
                                         ),
                                         Container(
                                           width: width1*0.3,
                                           //alignment: Alignment.center,
                                           color: data[i].strike>=currentStrike?Color(0xffFEEE96):Colors.white,
                                           child: Stack(
                                             children: [
                                               Container(
                                                 width:width2,
                                                 alignment: Alignment.centerRight,
                                                 child: Container(
                                                   height: 45,
                                                   width: width2*(double.parse(((data[i].putOi/totalPutOi)*100).toStringAsFixed(2))/100),
                                                   decoration: BoxDecoration(
                                                       color: Color(0xffFBC77C),
                                                       borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10))
                                                   ),
                                                 ),
                                               ),
                                               Align(
                                                 alignment: Alignment.center,
                                                 child: Container(
                                                   width: width1*0.3,
                                                   height: 17,
                                                   alignment: Alignment.center,
                                                   child:FittedBox(
                                                     child: Row(
                                                       children: [
                                                         Text(' ${data[i].putOi} ',style: ts14(textColor2),),
                                                         Text(' ${data[i].putOiChange} ',style: ts16(data[i].putOiChange>0?Color(0xff8CC1A8):Colors.red,fontSize: 15),),
                                                       ],
                                                     ),
                                                   ),

                                                 ),
                                               ),


                                             ],
                                           ),
                                           //  child: Text("${data[i].callOi}",style: ts14(textColor1),),
                                         ),

                                       ],
                                     ),
                                    /* Positioned(
                                       left: 0,
                                       child: Container(
                                         height: 45,
                                         width: 30,
                                         decoration: BoxDecoration(
                                           color: Color(0xffFBC77C)
                                         ),
                                       ),
                                     )*/
                                   ],
                                 ),
                               );
                             },

                           ),

                         ),
                         Container(
                           height: 25,
                           child: Row(
                             children: [
                               Spacer(),
                               Text("OI is displayed in contracts",style: ts14(textColor2,fontFamily: 'RM'),),
                               Spacer(),
                               Container(
                                 height: 6,
                                 width: 35,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(5),
                                   color: Color(0xffFBC77C)
                                 ),
                               ),
                               Text("   Open Interest",style: ts14(textColor2,fontFamily: 'RM'),),
                               Spacer(),
                             ],
                           ),
                         )
                       ],
                     ),
                    ),
                    Container(
                      color: Colors.white,
                    ),
                    Container(
                      color: Colors.white,
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ) ,
    );
  }
}
