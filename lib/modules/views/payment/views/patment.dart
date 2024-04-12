import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_firebase/modules/views/home/views/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../utils/helper/firestore_helper.dart';
import '../../../utils/model/api_model.dart';
import '../controller/checkboxcontroller.dart';

class payment extends StatelessWidget {
  payment({super.key});
  CheckboxController checkboxController = Get.put(CheckboxController());
  String? coupon;
  @override
  Widget build(BuildContext context) {
    Datamodel data = ModalRoute.of(context)!.settings.arguments as Datamodel;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Payment"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
            ),
          ),
        ),
        body: StreamBuilder(
            stream: FirestoreHelper.firestoreHelper.fetchcoupon(),
            builder: (ctx, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: GetBuilder<CheckboxController>(
                    builder: (ctx) => SizedBox(
                      height: Get.height,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: SizedBox(
                                    height: 200,
                                    width: 250,
                                    child: Image.network(data.image)),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Text(
                                "${data.title}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: checkboxController.check,
                                    onChanged: (val) {
                                      checkboxController.changevalu(val!);
                                    },
                                  ),
                                  const Text(
                                    "Apply Coupon",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              (checkboxController.check == true)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Enter Coupon code"),
                                        TextFormField(
                                          onChanged: (val) {
                                            coupon = val;
                                          },
                                          decoration: InputDecoration(
                                              label: const Text("coupon"),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            for (int i = 0;
                                                i < snapshot.data.docs.length;
                                                i++) {
                                              DocumentSnapshot ds =
                                                  snapshot.data.docs[i];
                                              log(ds['coupon']);
                                              if (ds['coupon'] == coupon) {
                                                {
                                                  if (ds['limit'] > 0) {
                                                    log("+++++++++++++++++++++++");
                                                    checkboxController
                                                            .discount =
                                                        ds['discount'];
                                                    Map<String, dynamic>
                                                        updata = {
                                                      "coupon": ds['coupon'],
                                                      "limit": ds['limit'] - 1,
                                                      "discount":
                                                          ds['discount'],
                                                      "id": ds['id'],
                                                    };
                                                    FirestoreHelper
                                                        .firestoreHelper
                                                        .updatecoupon(
                                                      newdata: updata,
                                                      id: ds['id'],
                                                    );
                                                  } else {
                                                    Fluttertoast.showToast(
                                                      msg: "Coupon Unavailable",
                                                    );
                                                  }
                                                }
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg: "Coupon Invalid",
                                                );
                                                log("-----------------------");
                                              }
                                            }
                                          },
                                          child: Center(
                                            child: Container(
                                              height: 40,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                              ),
                                              child: const Center(
                                                child: Text("submit"),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 50,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  Map<String, dynamic> newdata = {
                                    "category": data.category,
                                    "description": data.description,
                                    "id": data.id,
                                    "image": data.image,
                                    "price": data.price,
                                    "rating": {
                                      "count": data.rating['count'] - 1,
                                      "rate": data.rating['rate'],
                                    },
                                    "title": data.title
                                  };
                                  await FirestoreHelper.firestoreHelper
                                      .updatedata(
                                          newdata: newdata, id: data.id);
                                  Get.to(home());
                                },
                                child: Container(
                                  height: 60,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Pay \$${checkboxController.sum(n: data.price)}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              ;
              return const CircularProgressIndicator();
            }));
  }
}
