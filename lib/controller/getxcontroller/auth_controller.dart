import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../services/constants.dart';
import '../model/response_model.dart';
import '../model/usersdata_model.dart';
import '../repositories/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  List<UsersData> allUsersData = []; // Keep original data
  List<UsersData> usersData = []; // Filtered data
  List<String> uniqueCountries = [];
  bool isFinished = false;

  String? _selectedCountry;
  String? _selectedGender;

  Future<ResponseModel> getUsersData({
    int? offset,
    int? skip,
    bool isClear = false,
  }) async {
    ResponseModel responseModel;
    _isLoading = true;
    update();
    log("Fetching data from: ${AppConstants.baseUrl}${AppConstants.users}", name: "getUsersData");

    try {
      if (isClear) {
        allUsersData.clear();
        usersData.clear();
        isFinished = false;
      }

      if (isFinished) {
        return ResponseModel(true, 'No more data');
      }

      log('Skip: $skip', name: "SKIP");
      Response response = await authRepo.getUsersData(skip: skip);
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}', name: "getUsersData");

      if (response.statusCode == 200) {
        var data = usersDataFromJson(jsonEncode(response.body['users']));
        if (data.isEmpty) {
          isFinished = true;
        } else {
          allUsersData.addAll(data);
          usersData = List.from(allUsersData); // Initialize filtered data with all users
          uniqueCountries = usersData.map((user) => user.address?.country ?? "").toSet().toList();
          uniqueCountries.forEach((element) {
            log('Unique country: $element');
          });
        }
        responseModel = ResponseModel(true, '${response.body['message']}', response.body);
      } else {
        responseModel = ResponseModel(false, '${response.body['message']}', response.body);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Exception occurred");
      log('Exception: ${e.toString()}', name: "ERROR AT getUsersData()");
    } finally {
      _isLoading = false;
      update();
    }

    return responseModel;
  }

  void filterData({String? country, String? gender}) {
    usersData = allUsersData.where((user) {
      bool matchesCountry = country == null || country.isEmpty || user.address?.country == country;
      bool matchesGender = gender == null || user.gender?[0].toLowerCase() == gender[0].toLowerCase();
      return matchesCountry && matchesGender;
    }).toList();
    update();
  }

  void filterCountryData(String? country) {
    _selectedCountry = country;
    filterData(country: country, gender: _selectedGender);
  }

  void filterGenderData(String? gender) {
    _selectedGender = gender;
    filterData(country: _selectedCountry, gender: gender);
  }
}
