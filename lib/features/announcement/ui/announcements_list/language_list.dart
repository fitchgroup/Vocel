import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/common/utils/language.dart';
import 'package:vocel/common/utils/language_constants.dart';
import 'package:vocel/simple_app.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(constants.primaryColorDark),
        title: const Text("Language Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: Language.languageList().length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Card(
                  child: ListTile(
                    onTap: () async{
                      MyApp.setLocale(context, Locale(Language.languageList()[index].languageCode, ''));
                      await showDialog(
                          builder: (context) => AlertDialog(
                            title: const Text('Notice'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  const Text('Vocel App Language Changes'),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0,4,0,0),
                                    child: TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Confirm')
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          context: context
                      );
                      },
                    title: Text(Language.languageList()[index].name),
                  )
                ),
              );
            }
        )


        // DropdownButton<Language>(
        //   underline: const SizedBox(),
        //   icon: const Icon(
        //     Icons.language,
        //     color: Colors.white,
        //   ),
        //   onChanged: (Language? language) async {
        //     if (language != null) {
        //       Locale _locale = await setLocale(language.languageCode);
        //       MyApp.setLocale(context, _locale);
        //     }
        //   },
        //   items: Language.languageList()
        //       .map<DropdownMenuItem<Language>>(
        //         (e) => DropdownMenuItem<Language>(
        //       value: e,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceAround,
        //         children: <Widget>[
        //           Text(
        //             e.flag,
        //             style: const TextStyle(fontSize: 30),
        //           ),
        //           Text(e.name)
        //         ],
        //       ),
        //     ),
        //   )
        //       .toList(),
        // ),
      ),
    );
  }
}
