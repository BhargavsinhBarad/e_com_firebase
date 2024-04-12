import 'dart:convert';
import 'dart:developer';

import 'package:e_com_firebase/modules/utils/helper/firestore_helper.dart';
import 'package:http/http.dart' as http;

import '../model/api_model.dart';

class apihelper {
  apihelper._();
  static final apihelper api = apihelper._();

  Future getdata() async {
    String api = "https://fakestoreapi.com/products";
    var ans = await http.get(Uri.parse(api));
    if (ans.statusCode == 200) {
      var body = ans.body;
      List mapdata = jsonDecode(body);
      log("${mapdata.length}");
      for (int i = 0; i <= mapdata.length; i++) {
        await FirestoreHelper.firestoreHelper
            .adddata(data: mapdata[i], id: mapdata[i]['id']);
      }
    } else {
      return null;
    }
  }
}
