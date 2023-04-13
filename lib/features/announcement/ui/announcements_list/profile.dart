import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/ui/announcements_list/edit_profile.dart';
import 'package:vocel/features/announcement/ui/announcements_list/setting_page.dart';

class VocelProfile extends StatefulWidget {
  const VocelProfile({Key? key}) : super(key: key);

  @override
  State<VocelProfile> createState() => _VocelProfileState();
}

class _VocelProfileState extends State<VocelProfile> {
  @override
  Widget build(BuildContext context) {

    final signInTiles = ['username & password', 'Face ID', 'Delete digital profile'];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            heroTag: 0,
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
          "Profile && Account Settings",
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      body: Stack(
        children: [
      SingleChildScrollView(
      child: Column(
      mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 287.8,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  color: Color(constants.primaryColorDark),
                  offset: Offset(0, 2),
                )
              ],
              gradient: const LinearGradient(
                colors: [Color(constants.primaryColorDark), Color(constants.primaryColorDark)],
                stops: [0, 1],
                // in a coordinate space that maps the center of the paint box at (0.0, 0.0) and the bottom right at (1.0, 1.0).
                begin: AlignmentDirectional(0.94, -1),
                end: AlignmentDirectional(-0.94, 1),
              ),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Stack(
              children: [
                Padding(
                  padding:
                  const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              7, 40, 7, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Card(
                                clipBehavior:
                                Clip.antiAliasWithSaveLayer,
                                color: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(0),
                                ),
                                child: Stack(
                                  alignment:
                                  const AlignmentDirectional(1, 1),
                                  children: [
                                    Align(
                                      alignment:
                                      const AlignmentDirectional(0, 0),
                                      child: Container(
                                          width: 160,
                                          height: 160,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child:
                                          // Image.network(
                                          //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcZsL6PVn0SNiabAKz7js0QknS2ilJam19QQ&usqp=CAU',
                                          //   fit: BoxFit.fill,
                                          // ),
                                          Image.asset('images/vocel_logo.png')
                                      ),
                                    ),
                                    Align(
                                      alignment: const AlignmentDirectional(
                                          0, 0.6),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(1, 0, 0, 0),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                            shape: BoxShape.circle,
                                          ),
                                          child:
                                          SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: FloatingActionButton(
                                              elevation: 0,
                                              heroTag: "btn1",
                                              backgroundColor: Colors.blueGrey.shade500,
                                              shape: StadiumBorder(
                                                  side: BorderSide(
                                                    color: Colors.grey.shade200,
                                                    width: 2,
                                                    strokeAlign: BorderSide.strokeAlignInside,
                                                  )
                                              ),
                                              // shape: BeveledRectangleBorder(
                                              //     borderRadius: BorderRadius.circular(0)
                                              // ),
                                              // borderdth: 3,
                                              // buttonSize: 30,
                                              // fillColor:
                                              // Color(0xFF49AEE2),
                                              child: const Icon(
                                                Icons.mode_edit,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              onPressed: () async {
                                                // await signOut();
                                                // await Navigator
                                                //     .pushAndRemoveUntil(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         LoginPagedget(),
                                                //   ),
                                                //       (r) => false,
                                                // );
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => VocelSetting(
                                                  ),
                                                ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),      // profile image
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 2, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text(
                                // valueOrDefault<String>(
                                //   mYProfilePageUsersRecord
                                //       .displayName,
                                'testing',
                                // ),
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),   // name
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // user id
                            // Padding(
                            //   padding: const EdgeInsetsDirectional.fromSTEB(
                            //       0, 8, 0, 0),
                            //   child: Text(
                            //     'Id: ${authmodel.authInfo?.id}',
                            //   ),
                            // ),
                            // user email
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  4, 8, 0, 0),
                              child: Text(
                                "Email: testing",
                                style: TextStyle(
                                    color: Colors.blueGrey[500],
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),   // email
                    ],
                  ),
                ),
                if (Theme.of(context).brightness == Brightness.dark)
                  Align(
                    alignment: const AlignmentDirectional(1, -0.85),
                    child: Padding(
                      padding:
                      const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                      child: SizedBox(
                        height: 46,
                        width: 46,
                        child: FloatingActionButton(
                          heroTag: "btn2",
                          backgroundColor: Colors.transparent, // Back Button Color
                          // foregroundColor: Colors.transparent,
                          elevation: 0,
                          shape: const StadiumBorder(
                              side: BorderSide(
                                color: Colors.transparent,
                                width: 0,
                                strokeAlign: BorderSide.strokeAlignInside,
                              )
                          ),
                          // buttonSize: 46,
                          child: const Icon(
                            Icons.brightness_5_outlined,
                            // color:
                            // FlutterFlowTheme.of(context).textColor,
                            // size: 24,
                            color: Colors.grey,
                          ),
                          onPressed: () async {
                            // setDarkModeSetting(
                            //     context, ThemeMode.light);
                            // changeDarkMode(0);
                            //themeModel.toggleMode();
                            // Provider.of<ThemeModel>(context, listen: false).toggleMode();
                          },
                        ),
                      ),
                    ),
                  ),
                if (!(Theme.of(context).brightness == Brightness.dark))
                  Align(
                    alignment: const AlignmentDirectional(1, -0.85),
                    child: Padding(
                      padding:
                      const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                      child: SizedBox(
                        height: 46,
                        width: 46,
                        child: FloatingActionButton(
                          heroTag: "btn3",
                          backgroundColor: Colors.transparent, // Back Button Color
                          // foregroundColor: Colors.transparent,
                          elevation: 0,
                          shape: const StadiumBorder(
                              side: BorderSide(
                                color: Colors.transparent,
                                width: 0,
                                strokeAlign: BorderSide.strokeAlignInside,
                              )
                          ),
                          // buttonSize: 46,
                          child: const Icon(
                            Icons.brightness_2_outlined,
                            color: Colors.white,
                            // color:
                            // FlutterFlowTheme.of(context).textColor,
                            // size: 24,
                          ),
                          onPressed: () async {
                            // setDarkModeSetting(context, ThemeMode.dark);
                            // changeDarkMode(1);
                            //themeModel.toggleMode();
                            // Provider.of<ThemeModel>(context, listen: false).toggleMode();
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding:
            const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                  const EdgeInsetsDirectional.fromSTEB(0, 0, 6, 0),
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.grey.shade800,
                    size: 30,
                  ),
                ),
                Text(
                  // FFLocalizations.of(context).getText(
                  //   'f1bvbey3' /* My Account */,
                  // ),
                  // style: FlutterFlowTheme.of(context).bodyText1,
                    " My Account",
                    style: TextStyle(
                      color: Colors.grey[800],
                    )
                ),
              ],
            ),
          ), // My account
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileWidget(
                        // userProfile:
                        // mYProfilePageUsersRecord.reference,
                      ),
                    ),
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade500,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 4, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 6, 0),
                                    child: Icon(
                                      Icons.mode_edit,
                                      color: Colors.grey.shade700,
                                      size: 24,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Edit Profiles",
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: SizedBox(
                              height: 46,
                              width: 46,
                              child: FloatingActionButton( // should change it to IconButton
                                heroTag: "btn4",
                                backgroundColor: Colors.transparent, // Back Button Color
                                // foregroundColor: Colors.transparent,
                                elevation: 0,
                                shape: StadiumBorder(
                                    side: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 0,
                                      strokeAlign: BorderSide.strokeAlignInside,
                                    )
                                ),
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.grey.shade700,
                                  size: 25,
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VocelSetting(
                                    ),
                                  ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ), // edit profile
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: Material(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                    Colors.grey.shade500,
                    width: 1,
                  ),
                ),
                child: ExpansionTile(
                  title:
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional
                                    .fromSTEB(0, 0, 6, 0),
                                child: Icon(
                                  Icons.lock_outline,
                                  color: Colors.grey.shade700,
                                  size: 24,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Sign-in preferences",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  initiallyExpanded: false,
                  children: signInTiles.map((signInTiles) =>
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 4, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsetsDirectional
                                        .fromSTEB(0, 0, 6, 0),
                                  ),
                                  Expanded(
                                    child: Text(
                                      // FFLocalizations.of(context)
                                      //     .getText(
                                      //   '03k0vw86' /* Sign-in preferences */,
                                      // ),
                                      // style:
                                      // FlutterFlowTheme.of(context)
                                      //     .bodyText1,
                                      signInTiles,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: SizedBox(
                              height: 46,
                              width: 46,
                              child: FloatingActionButton(
                                heroTag: "btn5",
                                backgroundColor: Colors.transparent, // Back Button Color
                                // foregroundColor: Colors.transparent,
                                elevation: 0,
                                shape: StadiumBorder(
                                    side: BorderSide(
                                      color: Colors.grey.shade200,
                                      width: 0,
                                      strokeAlign: BorderSide.strokeAlignInside,
                                    )
                                ),
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.grey.shade700,
                                  size: 25,
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const VocelSetting(
                                    ),
                                  ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                  ).toList(),
                ),
              ), //
            ),
          ),//
        ],
      ),
    ),]
    ),
    );
  }
}
