import 'package:get/get.dart';

import 'services/http_service.dart';

Future<void> registerServices() async {
  Get.put(HTTPService());
}
