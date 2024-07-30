import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/input_decoration.dart';
import '../../services/theme.dart';

///TODO: Define toString() method for the model or Pass a data as List of String.
class DropDownKiller<T> extends StatefulWidget {
  const DropDownKiller(
      {super.key,
      required this.data,
      required this.onSelected,
      this.title = "Search"});
  final String? title;
  final List<T> data;
  final Function(T result) onSelected;

  @override
  State<DropDownKiller<T>> createState() => _DropDownKillerState<T>();
}

class _DropDownKillerState<T> extends State<DropDownKiller<T>> {
  List<T> searchedList = [];

  TextEditingController textEditingController = TextEditingController();

  onSearched(String key) {
    searchedList.clear();
    for (var element in widget.data) {
      if (element.toString().toLowerCase().contains(key.toLowerCase())) {
        searchedList.add(element);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    bool searched = textEditingController.text.isNotEmpty;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        // titleSpacing: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        title: TextFormField(
          autofocus: true,
          controller: textEditingController,
          onChanged: onSearched,
          decoration: CustomDecoration.inputDecoration(
            prefixWidget: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                size: 24,
              ),
            ),
            borderColor: Colors.white,
            label: "Search",
            suffix: textEditingController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      textEditingController.clear();
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.cancel,
                    ),
                  )
                : null,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: searched ? searchedList.length : widget.data.length,
        itemBuilder: (context, int index) {
          return GestureDetector(
            onTap: () {
              searched
                  ? widget.onSelected(searchedList[index])
                  : widget.onSelected(widget.data[index]);
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 14),
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Row(
                children: [
                  // Image.asset(
                  //   Assets.iconsSearchOutline,
                  //   height: 20,
                  //   width: 20,
                  // ),
                  // const SizedBox(
                  //   width: 16,
                  // ),
                  Text(
                    searched
                        ? searchedList[index].toString()
                        : widget.data[index].toString(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: textPrimary,
                        ),
                  ),
                  // const Spacer(),
                  // const Icon(
                  //   Icons.arrow_right_outlined,
                  //   size: 24,
                  // )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
