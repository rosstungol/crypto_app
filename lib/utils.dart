import 'package:get/get.dart';

import 'controllers/assets_controller.dart';
import 'services/http_service.dart';

Future<void> registerServices() async {
  Get.put(HTTPService());
}

Future<void> registerControllers() async {
  Get.put(AssetsController());
}
