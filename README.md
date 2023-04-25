# Vocel
Open source communications app for Vocel

To use...

Set up an Amplify back end with Authentication as per...

Configure amplify:
https://catalog.us-east-1.prod.workshops.aws/workshops/8b6f6ff9-b7a5-41b2-a8fa-9918b5553553/en-US/03-setting-up-the-development-environment

Add Amplify authentication category to the app:
https://catalog.us-east-1.prod.workshops.aws/workshops/8b6f6ff9-b7a5-41b2-a8fa-9918b5553553/en-US/05-add-amplify-authentication 

## 1 -- replace these constants in amplifyconfiguration.dart...

COGNITO_CREDS_POOL_ID
COGNITO_CREDS_REGION
COGNITO_USER_POOL_ID
COGNITO_USER_APP_CLIENT_ID
COGNITO_USER_REGION

##### pass amplifyconfiguration.dart in command line:
- In Android Studio, go to Edit Configuration
- In Additional run args
```
--dart-define=VERSION="the const string in amplifyconfiguration.dart"
```
- pass the string to amplifyConfig, *VERSION* is just the variable name
```dart
const String amplifyConfig = String.fromEnvironment('VERSION');
```

## 2 -- from the root directory, run "flutter gen-l10n"
https://docs.flutter.dev/development/accessibility-and-localization/internationalization
Notice that when you create l10n and create the arb files, gen_l10n folder will be generated under flutter_gen under .dart_tool
(app_localization.dart has the same name defined in l10n.yaml)

To build for deployment...

flutter clean
flutter build appbundle

To administer users and groups...

1. Enable Amplify Studio for your backend instance
2. Follow these instructions...

https://docs.amplify.aws/console/auth/user-management/

Create groups called ...

* Educators
* Staff
