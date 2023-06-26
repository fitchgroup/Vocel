# Vocel

Open source communications app for Vocel

To use...

Set up an Amplify back end with Authentication as per...

Configure amplify:
https://catalog.us-east-1.prod.workshops.aws/workshops/8b6f6ff9-b7a5-41b2-a8fa-9918b5553553/en-US/03-setting-up-the-development-environment

Add Amplify authentication category to the app:
https://catalog.us-east-1.prod.workshops.aws/workshops/8b6f6ff9-b7a5-41b2-a8fa-9918b5553553/en-US/05-add-amplify-authentication

## Initializing Amplify in a Flutter project summary:

### install the Amplify CLI

1. Check the system requirements:
    - Amplify CLI requires Node.js and NPM to be installed on your machine.

2. Install the Amplify CLI using NPM:
    - Run the following command in your terminal or command prompt:
      ```
      npm install -g @aws-amplify/cli
      ```

3. Verify the installation:
    - Run `amplify --version` in your terminal or command prompt to ensure the CLI was installed
      successfully.

4. Configure Amplify:
    - Run `amplify configure` to set up the CLI with your AWS account credentials and region.
    - Follow the prompts to enter your AWS access key, secret key, default region, and default
      output format.

5. Test the installation:
    - Run `amplify --help` to see the available commands and confirm that the CLI is working
      correctly.

### 1. Initialize Amplify:

- Navigate into your newly created Flutter project directory by running:
  ```
  cd <project_name>
  ```
- Once inside your project directory, initialize Amplify by running the following command:
  ```
  amplify init
  ```
- This command will guide you through the process of initializing Amplify for your project. You'll
  be prompted to provide a name for your environment, choose your preferred code editor, and set up
  an AWS profile. Follow the prompts and provide the required information.
-
reference: https://catalog.us-east-1.prod.workshops.aws/workshops/8b6f6ff9-b7a5-41b2-a8fa-9918b5553553/en-US/04-create-a-flutter-app/05-create-an-amplify-backend-for-the-app

#### Checking Amplify Environments after using amplify init

To check your existing environments in the Amplify Console website, you can follow these steps:

1. Open a web browser and go to the Amplify Console
   website: [https://console.aws.amazon.com/amplify/](https://console.aws.amazon.com/amplify/).
2. Sign in to your AWS account if you haven't already.
3. On the Amplify Console dashboard, select the app for which you want to check the environments.
4. Inside the app, navigate to the "Backend environments" section.
5. You'll find a list of your existing environments for the selected app, displaying their names,
   statuses, and associated resources.
6. Click on an environment to view more details, such as deployment history, logs, and
   configuration.

#### Modifying Amplify Environment

To modify the hosting configuration for your Amplify app, you can follow these steps:

1. Open the Amplify Console
   website: [https://console.aws.amazon.com/amplify/](https://console.aws.amazon.com/amplify/).
2. Sign in to your AWS account if you haven't already.
3. On the Amplify Console dashboard, select the app for which you want to change the hosting
   configuration.
4. Inside the app, navigate to the "Backend environments" section.
5. Click on the environment for which you want to change the hosting configuration.
6. Within the environment details, go to the "App settings" tab.
7. In the "App settings" tab, you'll find the hosting configuration options.
8. Make the desired changes to the hosting provider, custom domains, and branch mappings.
9. Click on the "Save" or "Apply" button to apply the new hosting configuration.

Please note that these steps are specific to the Amplify Console website and assume you have the
necessary permissions and access to the Amplify app and AWS resources.

### 2. Configure Amplify to use Cognito authentication:

    amplify add auth
    amplify update auth
    amplify push
    amplify publish

If you already have hosting configured for your Amplify project and you want to update and publish
your changes, you can skip the `amplify hosting add` step. Here's what you can do:

1. Make sure you are in your project directory in the command-line interface.
2. Run the following command to pull the latest backend changes:
    ```bash
    amplify pull --appId ...
    ```
   This command will synchronize your local backend with the remote backend environment specified
   by `appId` and `envName`.
3. After the pull is complete, you can make any necessary changes or updates to your project files.
4. Once you are ready to publish your changes, run **amplify publish**
   This command will package and deploy your project to the existing hosting environment configured
   for your Amplify project.

   By running `amplify publish`, Amplify will build and deploy your changes to the existing hosting
   environment without modifying or reconfiguring the hosting settings.

Note that if you have made changes to your hosting configuration (e.g., changing the hosting
provider, updating domain settings), you may need to reconfigure the hosting using
the `amplify hosting add` command before publishing.

### 3. add models to the app

    amplify add api
    amplify codegen models
    amplify push
    amplify publish

grapgQL syntax
refernce: https://docs.amplify.aws/cli/migration/transformer-migration/#changes-that-amplify-cli-will-auto-migrate-for-you

If the GraphQL schema file does not exist in the specified
path `...\\fitchVocel\amplify\#current-cloud-backend\api\fitchvocel\schema.graphql`, you have a few
options:

1. **Generate the schema**: If you have the schema defined elsewhere or if you can generate it from
   your backend, you can obtain or create the schema file. Make sure the file is
   named `schema.graphql`, and place it in the appropriate
   directory: `amplify/backend/api/fitchvocel/`.

2. **Copy the schema from another environment**: If you have previously configured the API in
   another environment (e.g., a different machine or a different branch in version control), you can
   copy the schema file from that environment to the current project. Ensure that the schema file is
   up to date and matches the desired API configuration.

3. **Regenerate the API**: If you don't have access to the original schema file or if it doesn't
   exist, you may need to regenerate the API. This process involves recreating the API backend,
   which includes generating a new schema file. Keep in mind that regenerating the API backend can
   result in the loss of any customizations or modifications made to the backend configuration or
   resolvers.

To regenerate the API backend, follow these steps:

- Run the following command from the root directory of your Amplify project:
  ```bash
  amplify api remove
  ```
- After removing the API, you can recreate it by running ... :
  ```bash
  amplify api add
  ```

### 4. can also add amplify push notification features to this project

-
refereces: https://docs.amplify.aws/lib/push-notifications/getting-started/q/platform/flutter/#set-up-backend-resources

### 5. To remove Amplify from your local environment and pull a new one, you can:

   ```bash
   amplify delete
   amplify pull --appId ...
   amplify pull
   ```

### 6. In this project, I used REST API to get user group information instead of using graphQL. *
Using REST API will require steps:* (reference: https://docs.amplify.aws/cli/auth/admin/)

## Amplify CLI - Auth Groups

The [Amplify CLI - Auth Groups](https://docs.amplify.aws/cli/auth/groups/) documentation provides
guidance on how to work with user groups in Amplify's authentication system. The main topics covered
in this documentation are:

- Introduction to Amplify Auth Groups
- Creating Auth Groups using the CLI
- Adding Users to Auth Groups
- Managing Auth Group Permissions
- Listing Auth Groups
- Updating Auth Group Attributes
- Deleting Auth Groups

The documentation provides detailed command-line examples for each operation, along with
explanations of the available options and parameters. It also highlights the importance of managing
group permissions to control access to various resources within your application.

## Amplify CLI - Auth Admin

The [Amplify CLI - Auth Admin](https://docs.amplify.aws/cli/auth/admin/) documentation focuses on
the administrative tasks related to Amplify's authentication system. It covers the following key
areas:

- Introduction to Amplify Auth Admin
- Creating and Managing User Pools
- User Pool Configurations and Customizations
- Managing User Pool Clients
- Configuring App Clients
- Customizing the Authentication Flow
- User Pool Domain and Hosted UI

The documentation explains how to use the Amplify CLI to create and configure user pools, manage
user pool clients, customize authentication flows, and set up domain names for the hosted
authentication UI. It provides detailed examples and instructions for each administrative task,
empowering you to configure and customize your authentication system according to your application's
requirements.


<br> 

---

<br>

# Use REST API in this flutter project

## 1. Exploring the precedence of different roles
```
/amplify/backend/auth/userPoolGroups/user-pool-group-precedence.json
```
Each object represents a group and provides information about the group's name ("groupName") and its precedence value ("precedence"). The precedence value indicates the priority or order in which these groups should be considered or processed, with lower numbers indicating higher precedence. You can set it in amplify console

## 2. Define function in this file: 

```
amplify/backend/function/AdminQueriesf35eea9e/src/app.js
```


1. Import required modules and dependencies:

   - `express`: Framework for building web applications.
   - `body-parser`: Middleware to parse request bodies.
   - `aws-serverless-express/middleware`: Middleware for AWS Serverless Express integration.
   - `cognitoActions`: Module containing functions for performing Cognito user management actions.


2. Configure CORS (Cross-Origin Resource Sharing):

   - Allow cross-origin requests by setting appropriate headers.

3. Define a middleware function to check if the user is in a specific group:

   - The `allowedGroup` variable represents the group name that is allowed to perform administrative tasks.
   - If the `allowedGroup` is not defined or set to `'NONE'`, all requests are allowed.
   - If the user is not in the allowed group, an error is returned.

4. Register endpoint handlers for various user management actions:

   - `/addUserToGroup`: Add a user to a group.
   - `/removeUserFromGroup`: Remove a user from a group.
   - `/confirmUserSignUp`: Confirm user sign-up.
   - `/disableUser`: Disable a user.
   - `/enableUser`: Enable a user.
   - `/getUser`: Get user information.
   - `/listUsers`: List users in the Cognito User Pool.
   - `/listGroups`: List groups in the Cognito User Pool.
   - `/listGroupsForUser`: List groups for a specific user.
   - `/listUsersInGroup`: List users in a specific group.
   - `/signUserOut`: Sign a user out (requires user verification).

5. Define error-handling middleware:

   - Log and handle errors that occur during request processing.

6. Start the Express application on port 3000.

### There is a file whose path is amplify/#current-cloud-backend/function/AdminQueriesxxxxxxx/AdminQueriesxxxxxxx-cloudformation-template.json

The provided file is an AWS CloudFormation template file. CloudFormation is an AWS service that allows you to describe and provision infrastructure resources in a declarative manner. The CloudFormation template file you shared is used for deploying an AWS Lambda function and its associated resources.

#### Template Breakdown

- **AWSTemplateFormatVersion**: Specifies the version of the CloudFormation template format.
- **Description**: Provides a description of the CloudFormation template.
- **Parameters**: Defines the input parameters for the CloudFormation stack.
- **Conditions**: Defines conditions based on which resources will be created or updated.
- **Resources**: Specifies the AWS resources to be provisioned, such as the Lambda function and its execution role.
- **Outputs**: Defines the outputs of the CloudFormation stack, such as the ARN (Amazon Resource Name) of the Lambda function.

In this specific template, it deploys an AWS Lambda function (`LambdaFunction`) along with its execution role (`LambdaExecutionRole`). The Lambda function is written in Node.js 16.x (`Runtime: "nodejs16.x"`) and has a handler function named `index.handler`. The function's code is stored in an S3 bucket (`Code.S3Bucket` and `Code.S3Key`).

The execution role (`LambdaExecutionRole`) is defined with an associated IAM policy (`lambdaexecutionpolicy`) that grants necessary permissions to the Lambda function. The permissions include actions related to logging, as well as various actions on a Cognito user pool (`cognito-idp`) for managing users and groups.

The `Outputs` section defines several outputs that can be useful for referencing the created resources, such as the Lambda function's name, ARN, and the execution role's ARN.

Overall, this CloudFormation template provides a way to deploy the Lambda function and its required resources in a structured and repeatable manner using AWS CloudFormation.


<br> 

---

<br>

#### Here's the breakdown of the key-value pairs:

- Key: "UserAgent"
    - Value: "aws-amplify-cli/2.0"
    - Description: Represents the user agent string used by the Amplify CLI.

- Key: "Version"
    - Value: "1.0"
    - Description: Specifies the version of the Amplify project.

- Key: "api"
    - Value: Represents the configuration for the API category in Amplify.

- Key: "plugins"
    - Value: Represents the plugins used within the API category.

- Key: "awsAPIPlugin"
    - Value: Represents the configuration for the AWS API plugin.

- Key: "vocelapp"
    - Value: Represents the API name or identifier.

- Key: "endpointType"
    - Value: "GraphQL"
    - Description: Specifies the type of API endpoint (in this case, GraphQL).

- Key: "endpoint"
    - Value: "https://***********.appsync-api.us-east-1.amazonaws.com/graphql"
    - Description: Specifies the endpoint URL for the API.

- Key: "region"
    - Value: "us-east-1"
    - Description: Specifies the AWS region where the API is deployed.

- Key: "authorizationType"
    - Value: "AMAZON_COGNITO_USER_POOLS"
    - Description: Specifies the authorization type used for the API (in this case, Amazon Cognito
      User Pools).

- Key: "apiKey"
    - Value: "***********"
    - Description: Specifies the API key used for authorization.

- Key: "auth"
    - Value: Represents the configuration for the Auth category in Amplify.

(The remaining keys and values within the "auth" section define various configuration settings
related to authentication and user management, including Cognito user pools, authentication flow
types, MFA configurations, etc.)

- Key: "storage"
    - Value: Represents the configuration for the Storage category in Amplify.

(The remaining keys and values within the "storage" section define the configuration for the AWS S3
storage plugin, including the bucket name, region, and default access level.)

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
Notice that when you create l10n and create the arb files, gen_l10n folder will be generated under
flutter_gen under .dart_tool
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

3. in the announcement widget, "**HookCunsumerWidget**" package that would allow you to build
   stateful widgets using hooks. Hooks are a way to manage state and perform side effects in a more
   concise and reusable manner compared to traditional Flutter StatefulWidget.

## Build and release guide:

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
```yaml
flutter_icons:
  android: true
  ios: true
  # change the icon of the app
  image_path: "assets/app_logo.png"
```
4. Save the `pubspec.yaml` file.
5. Open the terminal or command line and navigate to your Flutter project's location.
6. Run the following commands: `flutter clean`, `flutter pub get`
   , `flutter pub run flutter_launcher_icons:main`.
7. Wait for the icons to be generated.

#### Use the Rename Package

1. In your terminal or command line, activate the `rename` package by running the installation
   command.
```bash
pub global activate rename
```
2. Use the `pop global run rename --appname "Your app name"` command to set a new app name.
3. Enter your desired app name when prompted.
4. Check that the Android app name has changed successfully.

The command `pub global run rename --bundleId com.example.myapp` is used to change the bundle
identifier (package name) of a Flutter app. It helps in rebranding the app or ensuring uniqueness in
the app stores.
for example, change it to **pub global run rename --bundleId com.fitchandvocel.vocel**

Notice: A bundle identifier (bundleId) is not always required for deploying an app. However, it is
necessary if you want to distribute your app through app stores like Apple App Store or Google Play
Store. The bundle identifier acts as a unique identifier for your app, ensuring its proper
identification and updates on these platforms.

### Step 2: Upload and Publish Your Flutter App to the Play Store

#### Set Up Signing the App

1. Create a new file called `key.properties` in the `android` folder of your Flutter project.
2. Define the keystore password in the `key.properties` file.
3. Generate an upload keystore file by running the appropriate command for your operating system.
4. Move the generated keystore file to the `android/app` folder.
5. Update the keystore location in the `key.properties` file.

#### Configure Signing in Gradle

1. Open the `android/app/build.gradle` file.
2. Copy the code provided in the guide and paste it in the `android` section of the `build.gradle`
   file.
3. Remove the `android` part from the pasted code and adjust the spacing.
4. Save the `build.gradle` file.
5. In the terminal or command line, navigate to your Flutter project's root folder.
6. Run the command `flutter clean` to remove previous builds.
7. Run the command `flutter build app bundle` to create a signed app bundle.
8. Locate the generated app bundle file in the `build/app/outputs/bundle/release` folder.

### Step 3: Publish App Updates Automatically with Fastlane CI/CD Tool

1. Update the `.gitignore` file in the `android` folder to include `key.properties`
   and `upload-keystore.jks`.
2. Create a Google Play Developer account if you haven't already.
3. Sign in to your Google Play Developer account and create a new app.
4. Set up your app listing page, including app name, descriptions, graphics, and screenshots.
5. Configure store settings such as app category, contact information, and website.

`key.properties` and `upload-keystore.jks` are files used for signing Android apps before uploading
them to the Google Play Store.

- `key.properties` contains the configuration details, such as keystore location, passwords, and key
  alias, required for signing the app.
- `upload-keystore.jks` is the keystore file that holds cryptographic keys, including the private
  key used for signing the app.
