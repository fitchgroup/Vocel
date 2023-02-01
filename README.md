# Vocel
Open source communications app for Vocel

To use...

Set up an Amplify back end with Authentication as per...

https://catalog.us-east-1.prod.workshops.aws/workshops/8b6f6ff9-b7a5-41b2-a8fa-9918b5553553/en-US/05-add-amplify-authentication 

#1 -- replace these constants in amplifyconfiguration.dart...

COGNITO_CREDS_POOL_ID
COGNITO_CREDS_REGION
COGNITO_USER_POOL_ID
COGNITO_USER_APP_CLIENT_ID
COGNITO_USER_REGION

#2 -- from the root directory, run "flutter gen-l10n"

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
