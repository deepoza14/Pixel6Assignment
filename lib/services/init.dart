import 'dart:convert';
import 'dart:developer';


import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/api/api_calls.dart';
import '../controller/api/api_client.dart';
import '../controller/getxcontroller/auth_controller.dart';
import '../controller/repositories/auth_repo.dart';
import 'constants.dart';

class Init {


  initialize() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut<SharedPreferences>(() => sharedPreferences);

    try {
      // Todo: ApiRepo
      Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

      Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));


      // Todo: AuthController
      Get.lazyPut(() => AuthController(authRepo: Get.find()));

    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT initialize()");
    }
  }
}
