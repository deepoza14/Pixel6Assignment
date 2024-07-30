import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pixel6assignment/controller/getxcontroller/auth_controller.dart';
import 'package:pixel6assignment/services/extensions.dart';
import 'package:pixel6assignment/services/input_decoration.dart';

import '../services/dropdown_killer.dart';
import '../services/route_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _sortAscending = true;
  int? _sortColumnIndex;
  ScrollController _listScrollController = ScrollController();
  int offset = 1; // Initialize with your initial offset value
  final List<String> _genders = ['Male', 'Female'];
  String? _selectedGender;
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      Get.find<AuthController>().getUsersData(offset: offset, skip: 0, isClear: true);

      _listScrollController.addListener(() {
        // Check if user has scrolled close to the end of the list
        if (_listScrollController.position.pixels >= _listScrollController.position.maxScrollExtent - 400) {
          // Trigger when 200 pixels from bottom
          loadMoreData();
        }
      });
    });
  }

  void loadMoreData() async {
    try {
      final authController = Get.find<AuthController>();
      if (authController.isLoading || authController.isFinished) {
        return;
      }

      offset += 1; // Increment offset
      log('Loading more data - Offset: $offset');
      await authController.getUsersData(offset: offset, skip: (offset - 1) * 20).then((value) {
        if(value.isSuccess){
          authController.filterData(country: _selectedCountry,gender: _selectedGender);
        }
      });
    } catch (e) {
      log('Error loading more data: $e', error: e);
    }
  }

  void _sortData(int columnIndex, bool ascending) {
    final authController = Get.find<AuthController>();
    switch (columnIndex) {
      case 0:
        authController.usersData.sort((a, b) {
          return ascending ? a.id!.compareTo(b.id!) : b.id!.compareTo(a.id!);
        });
        break;
      case 2:
        authController.usersData.sort((a, b) {
          final aName = '${a.firstName ?? ""} ${a.maidenName ?? ""} ${a.lastName ?? ""}';
          final bName = '${b.firstName ?? ""} ${b.maidenName ?? ""} ${b.lastName ?? ""}';
          return ascending ? aName.compareTo(bName) : bName.compareTo(aName);
        });
        break;
      case 3:
        authController.usersData.sort((a, b) {
          return ascending ? (a.age ?? 0).compareTo(b.age ?? 0) : (b.age ?? 0).compareTo(a.age ?? 0);
        });
        break;
    }
    authController.update();
  }

  void _onSort(int columnIndex) {
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumnIndex = columnIndex;
        _sortAscending = true;
      }
    });
    _sortData(columnIndex, _sortAscending);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text("Employees"),
        actions: [
          SizedBox(
            height: 40,
            width: 200,
            child: DropdownButtonFormField<String>(
              value: _selectedCountry,
              onChanged: (newValue) {
                setState(() {
                  _selectedCountry = newValue;
                });
                Get.find<AuthController>().filterCountryData(newValue);
              },
              items: Get.find<AuthController>().uniqueCountries.map((country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              style: Theme.of(context).textTheme.labelLarge,
              decoration: CustomDecoration.inputDecoration(
                borderRadius: 6,
                hint: 'Country',
              ),
            ),
          ),
          const SizedBox(width: 15),
          SizedBox(
            height: 40,
            width: 200,
            child: DropdownButtonFormField<String>(
              value: _selectedGender,
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
                log(newValue!.toLowerCase(), name: "Gender");
                Get.find<AuthController>().filterGenderData(newValue);
              },
              items: _genders.map((gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              style: Theme.of(context).textTheme.labelLarge,
              decoration: CustomDecoration.inputDecoration(
                borderRadius: 6,
                hint: 'Gender',
              ),
            ),
          ),
          const SizedBox(width: 15)
        ],
      ),
      body: GetBuilder<AuthController>(builder: (authController) {
        // var userData = authController.usersData.where((user) {
        //   bool matchesGender = _selectedGender == null ||
        //       user.gender?[0].toLowerCase() == _selectedGender?.toLowerCase();
        //   bool matchesCountry = _selectedCountry == null ||
        //       user.address?.country == _selectedCountry;
        //
        //   // Debugging output
        //   log('Filtering user: ${user.id}, Gender: ${user.gender}, Country: ${user.address?.country}');
        //   log('Matches Gender: $matchesGender, Matches Country: $matchesCountry');
        //
        //   return matchesGender && matchesCountry;
        // }).toList();
        return SingleChildScrollView(
          controller: _listScrollController,
          physics: AlwaysScrollableScrollPhysics(),
          child: DataTable(
            sortAscending: _sortAscending,
            sortColumnIndex: _sortColumnIndex,
            columns: [
              DataColumn(
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ID',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(),
                    textAlign: TextAlign.start,
                  ),
                ),
                onSort: (columnIndex, _) {
                  _onSort(columnIndex);
                },
                numeric: true,
              ),
              DataColumn(
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Image',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              DataColumn(
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Full Name',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(),
                    textAlign: TextAlign.start,
                  ),
                ),
                onSort: (columnIndex, _) {
                  _onSort(columnIndex);
                },
              ),
              DataColumn(
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Demography',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(),
                    textAlign: TextAlign.start,
                  ),
                ),
                onSort: (columnIndex, _) {
                  _onSort(columnIndex);
                },
              ),
              DataColumn(
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Designation',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              DataColumn(
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Location',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ],
            rows: authController.usersData.map((user) {
              return DataRow(
                cells: [
                  DataCell(Container(
                    width: size.width * .02,
                    alignment: Alignment.centerLeft,
                    child: Text(user.id.toString(), textAlign: TextAlign.start),
                  )),
                  DataCell(Container(
                    width: size.width * .03,
                    alignment: Alignment.centerLeft,
                    child: Image.network(user.image ?? "", width: 50, height: 50),
                  )),
                  DataCell(Container(
                    width: size.width * .4,
                    alignment: Alignment.centerLeft,
                    child: Text('${user.firstName ?? ""} ${user.maidenName ?? ""} ${user.lastName ?? ""}', textAlign: TextAlign.start),
                  )),
                  DataCell(Container(
                    width: size.width * .1,
                    alignment: Alignment.centerLeft,
                    child: Text("${user.gender?[0].toUpperCase() ?? "NA"}, ${user.age ?? "1"}", textAlign: TextAlign.start),
                  )),
                  DataCell(Container(
                    width: size.width * .1,
                    alignment: Alignment.centerLeft,
                    child: Text("${user.company?.title}", textAlign: TextAlign.start),
                  )),
                  DataCell(Container(
                    width: size.width * .1,
                    alignment: Alignment.centerLeft,
                    child: Text('${user.address?.state ?? ""}, ${user.address?.country ?? ""}', textAlign: TextAlign.start),
                  )),
                ],
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}
