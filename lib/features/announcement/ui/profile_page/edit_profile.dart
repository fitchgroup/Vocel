import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/common/utils/manage_user.dart';
import 'package:vocel/features/announcement/ui/profile_page/selected_profile_image.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key});

  @override
  _EditProfileWidgetState createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
// late EditProfileModel _model;
//
// final scaffoldKey = GlobalKey<ScaffoldState>();
//
  @override
  void initState() {
    super.initState();
    backColor = [];
    getImagePalette('images/vocel_logo.png');
    getUserAttributesFromBackend().then((value) => null);
  }

  Future<void> getUserAttributesFromBackend() async {
    Map<String, String> stringMap = await getUserAttributes();
    for (var entry in stringMap.entries) {
      if (entry.key == "custom:name") {
        setState(() {
          userNameController.text = entry.value;
        });
      } else if (entry.key == "custom:region") {
        setState(() {
          userRegionController.text = entry.value;
        });
      } else if (entry.key == "custom:about") {
        setState(() {
          userAboutMeController.text = entry.value;
        });
      } else {
        continue;
      }
    }
  }

  File? image;
  late List<PaletteColor?> backColor;

// Calculate dominant color from ImageProvider
  void getImagePalette(String image) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(AssetImage(image));
    backColor.clear();
    if (paletteGenerator.lightMutedColor != null) {
      backColor.add(paletteGenerator.lightVibrantColor);
    }
    setState(() {});
  }

  final userNameController = TextEditingController();
  final userAboutMeController = TextEditingController();
  final userRegionController = TextEditingController();

  /// instead of using FocusNode(), use FocusScopeNode()
  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeRegion = FocusNode();
  final FocusNode _focusNodeAboutMe = FocusNode();

  void _handleTap(FocusNode focusNode) {
    setState(() {});
  }

  void _handleFieldSubmitted() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double coverHeight = 200;
    const double profileHeight = 100;

    return Scaffold(
// key: scaffoldKey,
      backgroundColor: const Color(constants.primaryColorDark),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent, // Back Button Color
            elevation: 0,
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white, // Back Icon Color
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text(
          "Edit Profile",
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 1,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: profileHeight / 2),
                  width: MediaQuery.of(context).size.width,
                  height: coverHeight,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        color: backColor.isNotEmpty
                            ? backColor[0]!.color.withAlpha(200)
                            : const Color(constants.primaryColorDark),
                        offset: const Offset(0, 3),
                      )
                    ],
                    gradient: LinearGradient(
                      colors: [
                        (backColor.isNotEmpty
                            ? backColor[0]!
                                .color
                                .withGreen(200)
                                .withRed(200)
                                .withBlue(200)
                            : const Color(constants.primaryLightTeal)),
                        (backColor.isNotEmpty
                            ? backColor[0]!.color
                            : const Color(constants.primaryLightTeal))
                      ],
                      stops: const [0, 1],
// in a coordinate space that maps the center of the paint box at (0.0, 0.0) and the bottom right at (1.0, 1.0).
                      begin: const AlignmentDirectional(0.94, -1),
                      end: const AlignmentDirectional(-0.94, 1),
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Positioned(
                    top: coverHeight - profileHeight / 2 * 1.5,
                    child: ProfilePic(profileHeight: profileHeight.toString()))
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 60, 20, 0),
                  child: TextFormField(
                    onTap: () => _handleTap(_focusNodeName),
                    onFieldSubmitted: (_) => _handleFieldSubmitted(),
                    obscureText: false,
                    focusNode: _focusNodeName,
                    controller: userNameController,
                    decoration: InputDecoration(
                        labelText: "Name ",
                        labelStyle: const TextStyle(color: Colors.black54),
                        hintText: 'Enter your name... ',
                        hintStyle: const TextStyle(color: Colors.black54),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        filled: true,
                        fillColor: Colors.white24,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            20, 24, 20, 24),
                        prefixIcon: const Icon(Icons.person_outline,
                            color: Color(constants.primaryColorDark))),
                    style: TextStyle(
                        color: _focusNodeName.hasFocus
                            ? Colors.blueGrey[700]
                            : Colors.black38),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: TextFormField(
                    obscureText: false,
                    controller: userRegionController,
                    focusNode: _focusNodeRegion,
                    onTap: () => _handleTap(_focusNodeRegion),
                    onFieldSubmitted: (_) => _handleFieldSubmitted(),
                    decoration: InputDecoration(
                        labelText: "Region ",
                        labelStyle: const TextStyle(color: Colors.black54),
                        hintText: 'Enter your region... ',
                        hintStyle: const TextStyle(color: Colors.black54),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        filled: true,
                        fillColor: Colors.white24,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            20, 24, 20, 24),
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: Color(constants.primaryColorDark))),
                    // keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                        color: _focusNodeRegion.hasFocus
                            ? Colors.blueGrey[700]
                            : Colors.black38),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: TextFormField(
                    obscureText: false,
                    onTap: () => _handleTap(_focusNodeAboutMe),
                    onFieldSubmitted: (_) => _handleFieldSubmitted(),
                    controller: userAboutMeController,
                    focusNode: _focusNodeAboutMe,
                    decoration: InputDecoration(
                        labelText: "About Me ",
                        labelStyle: const TextStyle(color: Colors.black54),
                        hintText: 'Info aboue me... ',
                        hintStyle: const TextStyle(color: Colors.black54),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular(23),
                        ),
                        filled: true,
                        fillColor: Colors.white24,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            20, 24, 20, 24),
                        prefixIcon: const Icon(Icons.assignment_ind_outlined,
                            color: Color(constants.primaryColorDark))),
                    textAlign: TextAlign.start,
                    maxLines: 4,
                    style: TextStyle(
                        color: _focusNodeAboutMe.hasFocus
                            ? Colors.blueGrey[700]
                            : Colors.black38),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(constants.primaryColorDark),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Edit personal information"),
                        content: const Text(
                            "Are you sure you want to save the changes?"),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop(
                                  false); // Dismiss the dialog and don't delete
                            },
                          ),
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () async {
                              addVocelUserAttribute(
                                  attrName: 'custom:name',
                                  attrValue: userNameController.text);
                              addVocelUserAttribute(
                                  attrName: 'custom:region',
                                  attrValue: userRegionController.text);
                              addVocelUserAttribute(
                                  attrName: 'custom:about',
                                  attrValue: userAboutMeController.text);
                              Navigator.of(context)
                                  .pop(false); // Dismiss the dialog and delete
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text("Save Changes"),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
