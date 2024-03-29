import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vocel/LocalizedMessageResolver.dart';
import 'package:vocel/common/utils/colors.dart' as constants;
import 'package:vocel/common/utils/language.dart';
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
                            title: Text(const LocalizedMessageResolver().notices(context)),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text(const LocalizedMessageResolver().vocelAppLanguageChanges(context)),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0,4,0,0),
                                    child: TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: Text(const LocalizedMessageResolver().confirm(context))
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
      ),
    );
  }
}
