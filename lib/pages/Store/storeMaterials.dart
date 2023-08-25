import 'package:flutter/material.dart';
import 'package:my_app/pages/Construction/constructionDetail.dart';
import 'dart:convert';
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import 'package:http/http.dart' as http;

class StoreMaterials extends StatefulWidget {
  StoreMaterials({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<StoreMaterials> createState() => _StoreMaterialsState(id: id);
}

class _StoreMaterialsState extends State<StoreMaterials> {
  @override
  final String id;

  var shoping_cart_items = [];
  var products = [];
  var keyword = TextEditingController();

  var baseurl = '';

  @override
  void initState() {
    get_products_modul(id);
    super.initState();
  }

  _StoreMaterialsState({required this.id});

  Widget build(BuildContext context) {
    return ListView(
      children: [
        Wrap(
          alignment: WrapAlignment.spaceAround,
          children: products.map((item) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ConstructionDetail(id: item['id'].toString())));
                },
                child: Card(
                    elevation: 2,
                    child: Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width / 3 - 10,
                        child: Column(children: [
                          Container(
                              alignment: Alignment.topCenter,
                              child: item['img'] != null && item['img'] != ""
                                  ? Image.network(
                                      baseurl + item['img'].toString(),
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width /
                                              3 -
                                          10,
                                      height: 130,
                                    )
                                  : Image.asset(
                                      'assets/images/default.jpg',
                                      height: 200,
                                    )),
                          Container(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    item['name'].toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: CustomColors.appColors,
                                        overflow: TextOverflow.clip),
                                  ),
                                  Text(
                                    item['price'].toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: CustomColors.appColors,
                                        overflow: TextOverflow.clip),
                                  ),
                                ],
                              ))
                        ]))));
          }).toList(),
        )
      ],
    );
  }

  void get_products_modul(id) async {
    Urls server_url = new Urls();
    var param = 'materials';
    String url = server_url.get_server_url() + '/mob/' + param + '?store=' + id;

    if (keyword.text != '') {
      url = server_url.get_server_url() +
          '/mob/' +
          param +
          '?store=' +
          id +
          "&name=" +
          keyword.text;
    }
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      products = json['data'];
      baseurl = server_url.get_server_url();
    });
  }
}
