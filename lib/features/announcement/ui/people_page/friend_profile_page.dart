import 'package:flutter/material.dart';
import 'package:vocel/LocalizedMessageResolver.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
// import 'package:vocel/features/announcement/ui/chat_page/chat_list/chat_box.dart';

class FriendProfile extends StatefulWidget {
  final String name;
  final String email;
  final String region;
  final String aboutMe;
  final String title;
  final String myInfo;

  FriendProfile({
    required this.name,
    required this.email,
    required this.region,
    required this.aboutMe,
    required this.title,
    required this.myInfo,
  });

  @override
  _FriendProfileState createState() => _FriendProfileState();
}

class _FriendProfileState extends State<FriendProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Container(
            height: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 6, // Allocate 65% of the available height
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: "Pangolin",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 4, // Allocate 35% of the available height
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 2,
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.width * 0.05),
            Center(
              child: ClipOval(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    color: Colors.blueGrey[100],
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 3.0),
                        blurRadius: 20.0,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image(
                      height: MediaQuery.of(context).size.width * 0.35,
                      width: MediaQuery.of(context).size.width * 0.35,
                      fit: BoxFit.cover,
                      image: const AssetImage('images/vocel_logo.png'),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            Row(
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 15.0),
                Container(
                  decoration: BoxDecoration(
                    color: widget.title == "leader" ? const Color(constants.primaryDarkTeal) : widget.title == "staff"
                        ? const Color(constants.primaryRegularTeal) : const Color(constants.primaryLightTeal),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.email,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.region,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'About',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.aboutMe,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.2),
            Center(
              child: InkWell(
                onTap: () async {
                  // Navigator.push(context, MaterialPageRoute
                  //   (builder: (context) =>
                  //   ChatPage(myInfo: widget.myInfo, theirInfo: widget.email, title: widget.title),
                  //    settings: const RouteSettings(arguments: "")
                  // ));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        const LocalizedMessageResolver().message(context),
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: "Pangolin",
                          letterSpacing: 2
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
