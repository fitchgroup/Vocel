import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vocel/LocalizedButtonResolver.dart';
import 'package:vocel/LocalizedMessageResolver.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/features/announcement/ui/setting_page/language_list.dart';

class VocelSetting extends StatefulWidget {
  const VocelSetting({Key? key}) : super(key: key);

  @override
  _VocelSetting createState() => _VocelSetting();
}

class _VocelSetting extends State<VocelSetting>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
        title: Text(
          const LocalizedButtonResolver().settings(context),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LanguageWidget()),
                );
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      const LocalizedMessageResolver().languages(context),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16,),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                // Add your custom logic here
                // May enable apple account, facebook account... in the future
                try {
                  await Amplify.Auth.signOut();
                } on AuthException catch (e) {
                  if (kDebugMode) {
                    print(e.message);
                  }
                }
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      const LocalizedButtonResolver().signOut(context),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


