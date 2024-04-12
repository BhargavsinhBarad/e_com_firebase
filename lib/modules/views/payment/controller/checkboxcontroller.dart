import 'package:get/get.dart';

class CheckboxController extends GetxController {
  bool check = false;
  int discount = 100;
  void changevalu(bool box) {
    check = box;
    update();
  }

  dynamic sum({required dynamic n}) {
    dynamic total;
    if (discount == 100) {
      total = n * discount / 100;
    } else {
      total = n - (n * discount / 100);
    }
    update();
    return total;
  }
}
