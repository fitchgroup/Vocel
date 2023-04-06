import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vocel/features/announcement/ui/announcements_list/language_list.dart';

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LanguageWidget(
                  ))
                );
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: const [
                    Text("Languages"),
                    SizedBox(
                      height: 30,
                    ),
                    Text("displaying language (will display setted language)")
                  ],
                )
              ),
            ),
            const Divider(thickness: 1, height: 10, color: Colors.grey,),
          ],
        ),
      ),
    );
  }
}


