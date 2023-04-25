import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vocel/common/utils/colors.dart' as constants;

class SearchBar extends StatefulWidget {
  const SearchBar({
    super.key,
    required this.onClickController,
  });

  final ValueChanged<String> onClickController;

  @override
  State<SearchBar> createState() => _SearchBarState(onClickController: onClickController);
}

class _SearchBarState extends State<SearchBar> {
  _SearchBarState({required this.onClickController});

  TextEditingController? queryController;
  ValueChanged<String> onClickController;

  @override
  void initState() {
    super.initState();
    queryController = TextEditingController();
  }

  @override
  void dispose() {
// TODO: implement dispose
    super.dispose();
    queryController?.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 4),
      child: TextFormField(
        onFieldSubmitted: (value) {
          setState(() {
            searchHelper();
          });
        },
        controller: queryController,
        obscureText: false,
        onChanged: (e) => setState(() {
          searchHelper();
        }),
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle:
          TextStyle(color: Colors.grey.shade400),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade500,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black12,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black12,
              width: 5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding:
          const EdgeInsetsDirectional.fromSTEB(
              20, 10, 20, 10),
          suffixIcon: InkWell(
            onTap: () => {
              if(queryController!.text != ""){
                setState(() {
                  queryController?.clear();
                })
              }
            },
            focusNode: FocusNode(skipTraversal: true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Icon(
                queryController!.text.isNotEmpty
                    ? Icons.cancel_outlined
                    : Icons.search,
                color: const Color(constants.primaryColorDark),
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void searchHelper() {
    onClickController(queryController!.text);
    if (kDebugMode) {
      print(queryController!.text);
    }
//     if (queryController!.text == "") {
//     } else {
//       queryController!.clear();
//     }
  }
}


