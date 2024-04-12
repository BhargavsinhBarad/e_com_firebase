import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_firebase/modules/utils/helper/api_helper.dart';
import 'package:e_com_firebase/modules/utils/helper/firestore_helper.dart';
import 'package:e_com_firebase/modules/utils/model/api_model.dart';
import 'package:e_com_firebase/modules/views/detail/views/detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class home extends StatelessWidget {
  home({super.key});
  // DataController dataController = Get.put(DataController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.changeTheme(
                  Get.isDarkMode ? ThemeData.light() : ThemeData.dark(),
                );
              },
              icon: Icon(Icons.sunny))
        ],
      ),
      body: StreamBuilder(
        stream: FirestoreHelper.firestoreHelper.fetchdata(),
        builder: (ctx, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 200,
                crossAxisCount: 2,
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (ctx, i) {
                DocumentSnapshot ds = snapshot.data.docs[i];
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () {
                      Datamodel dm = Datamodel(
                          id: ds['id'],
                          title: ds['title'],
                          image: ds['image'],
                          category: ds['category'],
                          description: ds['description'],
                          price: ds['price'],
                          rating: ds['rating']);
                      Get.to(detail(), arguments: dm);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 100,
                              child: Image.network("${ds['image']}"),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "${ds['title']}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
