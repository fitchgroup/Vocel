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
- in this project, the amplifyConfig is stored in lib/common/repository/auth_inject.dart
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

## Notes:
#### 1. backend logic:

##### Home page (announcement):

1. click the FloatingActionButton at the bottom right

2. bottomsheet pop up, enter the information would create a new annoucement

3. in the announcement widget, "**HookCunsumerWidget**" package that would allow you to build stateful widgets using hooks. Hooks are a way to manage state and perform side effects in a more concise and reusable manner compared to traditional Flutter StatefulWidget.









## After the app is build, we can build and release it:

### Step 1: Prepare Your Flutter App

#### Add App Icon

1. Go to Google and search for "Android Icon Generator."
2. Choose the first link to generate a new icon.
3. Select an icon from the clip art section or upload your own logo.
4. Adjust the padding as desired and download the zip file.
5. Extract the downloaded zip file and find the app logo.
6. Rename the logo file if necessary and move it to the assets folder in your Flutter project.

#### Use Flutter Launcher Icons Package

1. In your `pubspec.yaml` file, add the `flutter_launcher_icons` package as a dev dependency.
2. Make sure the spacing and formatting are correct.
3. Replace the image path in the `flutter_icons` section with the correct file name and location.
4. Save the `pubspec.yaml` file.
5. Open the terminal or command line and navigate to your Flutter project's location.
6. Run the following commands: `flutter clean`, `flutter pub get`, `flutter pub run flutter_launcher_icons:main`.
7. Wait for the icons to be generated.

#### Use the Rename Package

1. In your terminal or command line, activate the `rename` package by running the installation command.
2. Use the `pop global run rename` command to set a new app name.
3. Enter your desired app name when prompted.
4. Check that the Android app name has changed successfully.

The command `pub global run rename --bundleId com.example.myapp` is used to change the bundle identifier (package name) of a Flutter app. It helps in rebranding the app or ensuring uniqueness in the app stores.
for example, change it to **pub global run rename --bundleId com.example.myapp**

Notice: A bundle identifier (bundleId) is not always required for deploying an app. However, it is necessary if you want to distribute your app through app stores like Apple App Store or Google Play Store. The bundle identifier acts as a unique identifier for your app, ensuring its proper identification and updates on these platforms.


### Step 2: Upload and Publish Your Flutter App to the Play Store

#### Set Up Signing the App

1. Create a new file called `key.properties` in the `android` folder of your Flutter project.
2. Define the keystore password in the `key.properties` file.
3. Generate an upload keystore file by running the appropriate command for your operating system.
4. Move the generated keystore file to the `android/app` folder.
5. Update the keystore location in the `key.properties` file.

#### Configure Signing in Gradle

1. Open the `android/app/build.gradle` file.
2. Copy the code provided in the guide and paste it in the `android` section of the `build.gradle` file.
3. Remove the `android` part from the pasted code and adjust the spacing.
4. Save the `build.gradle` file.
5. In the terminal or command line, navigate to your Flutter project's root folder.
6. Run the command `flutter clean` to remove previous builds.
7. Run the command `flutter build app bundle` to create a signed app bundle.
8. Locate the generated app bundle file in the `build/app/outputs/bundle/release` folder.

### Step 3: Publish App Updates Automatically with Fastlane CI/CD Tool

1. Update the `.gitignore` file in the `android` folder to include `key.properties` and `upload-keystore.jks`.
2. Create a Google Play Developer account if you haven't already.
3. Sign in to your Google Play Developer account and create a new app.
4. Set up your app listing page, including app name, descriptions, graphics, and screenshots.
5. Configure store settings such as app category, contact information, and website.

`key.properties` and `upload-keystore.jks` are files used for signing Android apps before uploading them to the Google Play Store.

- `key.properties` contains the configuration details, such as keystore location, passwords, and key alias, required for signing the app.
- `upload-keystore.jks` is the keystore file that holds cryptographic keys, including the private key used for signing the app.
