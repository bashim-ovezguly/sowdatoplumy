import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
  
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Store/merketDetail.dart';
import '../../dB/colors.dart';
import '../../dB/textStyle.dart';
import '../call.dart';
import '../fullScreenSlider.dart';

class ServiceDetail extends StatefulWidget {
  ServiceDetail({Key? key,  required this.id}) : super(key: key);
  final String id ;

  @override
  State<ServiceDetail> createState() => _ServiceDetailState(id: id);
}

class _ServiceDetailState extends State<ServiceDetail> {
  
  final number = '+99364334578';
  int _current = 0;
  final String id ;
  var baseurl = "";
  var data = {};
  bool determinate = false;
  bool slider_img = true;
  List<String> imgList = [ ];

  void initState() {
    if (imgList.length==0){
      imgList.add('https://avatars.mds.yandex.net/i?id=2a00000179f8c0294d708c859d65cbc8412e-3985741-images-thumbs&n=13');
    }
    getsingleparts(id: id);
    super.initState();
  }

  _ServiceDetailState({required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Hyzmatlar", style: CustomText.appBarText,),
        actions: [],),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: CustomColors.appColors,
        onRefresh: ()async{
            setState(() {
            determinate = false;
            initState();
          });
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: determinate? ListView(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            textDirection: TextDirection.rtl,
            fit: StackFit.loose,
            clipBehavior: Clip.hardEdge,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: GestureDetector(
                  child:  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) {setState(() {_current = index;});}
                    ),
                    items: imgList
                        .map((item) => Container(
                      color: Colors.white,
                      child: Center(
                        child: ClipRect(
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            child:  FittedBox(
                              fit: BoxFit.cover,
                              child: item != ''  && slider_img==true ? Image.network(item.toString(),):
                              Image.asset('assets/images/default16x9.jpg'),),
                              ),),
                      ),)).toList(),),
                  onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenSlider(imgList: imgList) )); },),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: DotsIndicator(
                  dotsCount: imgList.length,
                  position: _current.toDouble(),
                  decorator: DotsDecorator(
                    color: Colors.white,
                    activeColor: CustomColors.appColors,
                    activeShape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),),),)
            ],
          ),
             Row(
              children: <Widget>[
                Expanded(flex: 4,child: Row(
                  children:  <Widget>[
                    SizedBox(width: 20,),
                    Icon(Icons.access_time_outlined,size: 20,color: CustomColors.appColors,),
                    SizedBox(width: 20,),
                    Text(data['created_at'].toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Raleway',
                        color: CustomColors.appColors,
                      ),
                    ),
                  ],
                ),),
                Spacer(),
                Expanded(child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children:  <Widget>[
                    Icon(Icons.visibility_sharp,size: 20,color: CustomColors.appColors,),
                    SizedBox(width: 10,),
                    Text(data['viewed'].toString(), style: TextStyle(fontSize: 16, fontFamily: 'Raleway', color: CustomColors.appColors,
                    ),),],),
                )
              ],
            ),

            Container(
            margin: EdgeInsets.only(left: 10,right: 10,top: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.auto_graph_outlined, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Id", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['id'].toString(), style: CustomText.size_16))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 40,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.category_outlined, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Kategoriýa", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['category'].toString(), 
                                            overflow: TextOverflow.clip,
                                            maxLines: 2,
                                            softWrap: false,
              
               style: CustomText.size_16))],),),
            
            if (data['store_id']!=null && data['store_id']!='')
            SizedBox(
              child: Row(
                children: [
                  Expanded(child: Row(
                  children: [
                    SizedBox(width: 20,),
                    Icon(Icons.store, color: Colors.black54),
                    SizedBox(width: 10,),
                    Text("Söwda nokat", style: CustomText.size_16_black54,)],),),

                   Expanded(child:Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 13, color: CustomColors.appColorWhite)),
                      onPressed: () {
                        if (data['store_id']!=null && data['store_id']!=''){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MarketDetail(id: data['store_name'].toString(), title: 'Söwda nokatlar')));
                        }
                      },
                      child: Text(data['store'].toString(),),)))
                ],
              ),
            ),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.drive_file_rename_outline_outlined, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Ady", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['name_tm'].toString(),  style: CustomText.size_16))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.price_change_rounded, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Bahasy", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['price'].toString(),  style: CustomText.size_16))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.location_on, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Ýerleşýän ýeri", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['location'].toString(),  style: CustomText.size_16))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.phone_callback, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Satyjy nomeri", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['phone'].toString(),  style: CustomText.size_16))],),),

          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 30,
            child: Row(children: [
              Expanded(child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(Icons.drive_file_rename_outline, color: Colors.black54,),
                  SizedBox(width: 10,),
                  Text("Satyjynyň ady", style: CustomText.size_16_black54,)],),),
              Expanded(child: Text(data['customer'].toString(),  style: CustomText.size_16))],),),
          
         if (data['ad'] != null && data['ad'] !='')
          Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Text(" Reklama hyzmaty",
                  style: TextStyle(
                      fontSize: 17,
                      color: CustomColors.appColors,
                      fontWeight: FontWeight.bold),),
                Container(
                  color: Color.fromARGB(96, 214, 214, 214),
                  child:  Image.network(baseurl + data['ad']!['img'].toString(), 
                      fit: BoxFit.fitHeight, height: 160, width: double.infinity),),
              ],),),
              
          if (data['description']!=null && data['description']!='')
          SizedBox(
              width: double.infinity,
              child: TextField(
                enabled: false, 
                decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,),
                filled: true,
                hintMaxLines: 10,
                hintStyle: TextStyle(fontSize: 14, color: CustomColors.appColors),
                hintText: data['description'].toString(),
                fillColor: Colors.white,),),),
        SizedBox(height: 70,),

        ],
      ): Center(child: CircularProgressIndicator(
        color: CustomColors.appColors,),),
      ),
    
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 30, left: 25),
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(top: 50),
        child: Call(phone: data['phone'].toString()),
      )
    );
  }

      void getsingleparts({required id}) async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/services/' + id;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
        data  = json;
        if (data['phone']==null || data['phone']==0){
          data['phone']= '';
        }
        baseurl =  server_url.get_server_url();
        // ignore: unused_local_variable
        var i;
        imgList = [];
        for ( i in data['images']) {
          imgList.add(baseurl + i['img_l']);
        }
        determinate = true;
      if (imgList.length==0){
        slider_img = false;
        imgList.add('https://avatars.mds.yandex.net/i?id=2a00000179f8c0294d708c859d65cbc8412e-3985741-images-thumbs&n=13');
      }});}


}
