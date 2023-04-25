import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:vocel/common/utils/colors.dart' as constants;


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
    getImagePalette('assets/images/default_profiles.png');
  }

//
// @override
// void dispose() {
//   _model.dispose();
//
//   super.dispose();
// }

  File? image;
  late List<PaletteColor?> backColor;

// Calculate dominant color from ImageProvider
  void getImagePalette(String image) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator
        .fromImageProvider(AssetImage(image));
    backColor.clear();
    if (paletteGenerator.lightMutedColor != null) {
      backColor.add(paletteGenerator.lightVibrantColor);
      if (kDebugMode) {
        print("here we go");
      }
    }
    setState(() {});
  }

  Future chooseImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageStore = await savePathImage(image.path);
      setState(() => this.image = imageStore);
    } on Exception catch (e) {
// TODO
      if (kDebugMode) {
// print(source.toString());
        print(e.toString());
        print("Fail to add image");
      }
    }
  }

  Future<File> savePathImage(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  Future<ImageSource?> showImageSource(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup(context: context,
          builder: (context) =>
              CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                      onPressed: () =>
                          Navigator.of(context).pop(ImageSource.camera),
                      child: const Text('Camera')
                  ),
                  CupertinoActionSheetAction(
                      onPressed: () =>
                          Navigator.of(context).pop(ImageSource.gallery),
                      child: const Text('Gallery')
                  ),
                ],
              )
      );
    }
    else { //if(Platform.isAndroid){
      return showModalBottomSheet(context: context,
          builder: (context) =>
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Camera'),
                    onTap: () => Navigator.of(context).pop(ImageSource.camera),
                  ),
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text('Gallery'),
                    onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                  ),
                ],
              )
      );
    }
// else {
//   return null;
// }
  }

  @override
  Widget build(BuildContext context) {
// return StreamBuilder<UsersRecord>(
//   stream: UsersRecord.getDocument(currentUserReference!),
//   builder: (context, snapshot) {
//     // Customize what your widget looks like when it's loading.
//     if (!snapshot.hasData) {
//       return Center(
//         child: SizedBox(
//           width: 40,
//           height: 40,
//           child: SpinKitPumpingHeart(
//             color: FlutterFlowTheme.of(context).primaryColor,
//             size: 40,
//           ),
//         ),
//       );
//     }
//     final editProfileUsersRecord = snapshot.data!;
    const double coverHeight = 200;
    const double profileHeight = 100;

    return Scaffold(
// key: scaffoldKey,
      backgroundColor: const Color(constants.primaryColorDark),
      appBar: AppBar(
// backgroundColor: Colors.blue, // AppBar Color
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
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height * 1,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: profileHeight / 2),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: coverHeight,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color:
                            backColor.isNotEmpty ? backColor[0]!.color
                                .withAlpha(200) : const Color(constants
                                .primaryColorDark),
                            offset: const Offset(0, 3),
                          )
                        ],
                        gradient: LinearGradient(
                          colors: [
                            (backColor.isNotEmpty ? backColor[0]!.color.withGreen(200).withRed(200).withBlue(200) : const Color(constants.primaryLightTeal)),
                            (backColor.isNotEmpty ? backColor[0]!.color : const Color(constants.primaryLightTeal))
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
                        child:
                        image != null ?
                        ClipOval(
                          child: Container(
                            child: InkWell(
                              onTap: () async {
                                final source = await showImageSource(context);
                                if (source == null) return;
                                chooseImage(source);
                              },
                              child: Image.file(
                                image!,
                                height: profileHeight * 1.5,
                                width: profileHeight * 1.5,
                              ),
                            ),
                          ),
                        )
                            :
                        ClipOval(
                          child: Container(
                            padding: const EdgeInsets.all(5),
// color: Colors.grey[100],
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              color: Colors.grey[100],
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 3.0), //(x,y)
                                  blurRadius: 20.0,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: InkWell(
                                onTap: () async {
                                  final source = await showImageSource(context);
                                  if (source == null) return;
                                  chooseImage(source);
                                },
                                child: const Image(
                                  fit: BoxFit.cover,
                                  height: profileHeight * 1.5,
                                  width: profileHeight * 1.5,
                                  image: AssetImage(
                                      'images/vocel_logo.png'
// 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcZsL6PVn0SNiabAKz7js0QknS2ilJam19QQ&usqp=CAU'
// 'https://www.computerhope.com/jargon/g/guest-user.png',
//'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIWzldjAy2NDfNAE8FAlKVMsoKIGU1B6CormNCp8RM1isll9a5x0fyXuhbejfdD2Lam4A&usqp=CAU',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 60, 20, 0),
                  child: TextFormField(
// controller: _model.yourNameController ??=
//     TextEditingController(
//       text: editProfileUsersRecord.displayName,
//     ),
                    obscureText: false,
                    decoration: InputDecoration(
// border: OutlineInputBorder(
//   borderRadius: BorderRadius.circular(100),
//   // borderRadius: BorderRadius.all(Radius.elliptical(30, 40))
// ),
                        labelText: 'Name ',
                        labelStyle:
                        const TextStyle(color: Colors.black54),
                        hintText: 'Enter your name... ',
                        hintStyle:
                        const TextStyle(color: Colors.black54),
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
                        contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(
                            20, 24, 20, 24),
                        prefixIcon: const Icon(
                            Icons.person_outline,
                            color: Color(constants.primaryColorDark)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: TextFormField(
// controller: _model.yourEmailController ??=
//     TextEditingController(
//       text: editProfileUsersRecord.email,
//     ),
                    obscureText: false,
                    decoration: InputDecoration(
                        labelText: 'Email Address ',
                        labelStyle:
                        const TextStyle(color: Colors.black54),
                        hintText: 'Enter your email... ',
                        hintStyle:
                        const TextStyle(color: Colors.black54),
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
                        contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(
                            20, 24, 20, 24),
                        prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Color(constants.primaryColorDark)
                        )
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: TextFormField(
// controller: _model.yourTitleController ??=

//     TextEditingController(
//       text: editProfileUsersRecord.userTitle,
//     ),
                    obscureText: false,
                    decoration: InputDecoration(
                        labelText: 'Title ',
                        labelStyle:
                        const TextStyle(color: Colors.black54),
                        hintText: 'Enter your title... ',
                        hintStyle:
                        const TextStyle(color: Colors.black54),
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
                        contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(
                            20, 24, 20, 24),
                        prefixIcon: const Icon(
                            Icons.workspaces_outline,
                            color: Color(constants.primaryColorDark)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: TextFormField(
// controller: _model.yourAgeController ??=
//     TextEditingController(
//       text: editProfileUsersRecord.age?.toString(),
//     ),
                    obscureText: false,
                    decoration: InputDecoration(
                        labelText: 'About Me',
                        labelStyle:
                        const TextStyle(color: Colors.black54),
                        hintText: 'Info aboue me... ',
                        hintStyle:
                        const TextStyle(color: Colors.black54),
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
                        contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(
                            20, 24, 20, 24),
                        prefixIcon: const Icon(
                            Icons.assignment_ind_outlined,
                            color: Color(constants.primaryColorDark)
                        )
                    ),
                    textAlign: TextAlign.start,
                    maxLines: 4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 20),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(constants.primaryColorDark),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                      onPressed: () async {}, child: const Text("Save Changes"),
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}