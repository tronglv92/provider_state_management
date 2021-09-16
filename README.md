## Localizations

https://flutter.dev/docs/development/accessibility-and-localization/internationalization

### Install `flutter_intl` tool
- JetBrains: https://plugins.jetbrains.com/plugin/13666-flutter-intl
- VS code: https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl

1. Add other locales:
- Run `Tools -> Flutter Intl -> Add Locale`

2. Access to the current locale
```
Intl.getCurrentLocale()
```

3. Change current locale
```
S.load(Locale('vi'));
```

4. Reference the keys in Dart code
```
Widget build(BuildContext context) {
    return Column(children: [
        Text(
            S.of(context).pageHomeConfirm,
        ),
        Text(
            S.current.pageHomeConfirm,// If you don't have `context` to pass
        ),
    ]);
}
```

### Generate intl via cli
```
#https://pub.dev/packages/intl_utils
flutter pub get
flutter pub run intl_utils:generate
```


## Structure
```
lib/
  |-generated/                     ---> auto genrated by flutter_intl
  |-l10n/                          ---> place internalization files
    |-intl_*.arb                   ---> define your translation text here
  |-models/                        ---> place object models
    |-local/                       ---> place local models
    |-remote/                      ---> place remote models
  |-pages/                         ---> define all pages/screens of application
    |-home/                        ---> place app home module included home ui and logic. We should organize as app module (eg: home, about, ...) rather then platform module (eg: activity, dialog, ...)
      |-home_page.dart             ---> define home ui
      |-home_provider.dart         ---> define home logic
  |-services/                      ---> place app services (database service, network service)
    |-app/                         ---> place local data services
      |-app_dialog.dart            ---> define app dialog service. Easy to show or hide alert dialog
      |-app_loading.dart           ---> define app loading service. Easy to show or hide loading view
      |-dynamic_size.dart          ---> define dynamic size service. Adapting screen and font size
      |-locale_provider.dart       ---> define locale provider service. Provide update locale
      |-state_safety.dart          ---> define sate safety service. It's used for Stateful widget, check mounted before setState
    |-cache/                       ---> place local data services
      |-credential.dart            ---> define app credential
      |-storage.dart               ---> define storage service
      |-storage_preferences.dart   ---> define storage with shared preferences service
    |-rest_api/                    ---> place remote services
      |-api.dart                   ---> define api base class
      |-api_error.dart             ---> define api error/exception handler
      |-api_user.dart              ---> define sample of api user
      |-error_type.dart            ---> define api error type
    |-safety/                      ---> place safety abstract class for widget, change notifier
      |-base_stateful.dart         ---> define base stateful widget, provide app theme, dynamic size
      |-base_stateless.dart        ---> define base stateless widget, provide app theme, dynamic size
      |-change_notifier_safety.dart---> define safety change notifier
      |-page_stateful.dart         ---> define stateful abstract for page 
      |-state_safety.dart          ---> define setState safety
    |-store/                       ---> place local store service
      |-store.dart                 ---> define abstract store
      |-store_mock.dart            ---> define mock store
  |-utils/                         ---> place app utils
    |-app_asset.dart               ---> define app assets
    |-app_config.dart              ---> define app config multi environment
    |-app_extension.dart           ---> define app extension
    |-app_helper.dart              ---> define app helper. Provide util function such as show popup, toast, flushbar, orientation mode
    |-app_log.dart                 ---> define app logger. Log safety with production mode
    |-app_route.dart               ---> define app route logic
    |-app_style.dart               ---> define app style
    |-app_theme.dart               ---> define app theme. Provide multi theme such as dart, light
  |-widgets/                       ---> place app widgets
    |-p_appbar_empty.dart          ---> define wrapper widget use for page, color status bar but empty appbar 
    |-p_appbar_transparency.dart   ---> define wrapper widget use for page, transparent status bar
    |-p_material.dart              ---> define wrapper widget use for page, provide material app block
    |-w_dismiss_keyboard.dart      ---> define component widget with auto dismiss keyboard when click on screen
  |-main.dart                      ---> each main.dart file point to each env of app. Ex: default main.dart for dev env, create new main_prod.dart for prod env
  |-my_app.dart                    ---> application bootstrap
test/                              ---> place app unit, widget tests
  |-counter_provider_test.dart     ---> define test provider script
  |-counter_widget_test.dart       ---> define test widget script
  |-navigator_test.dart            ---> define test navigator script
  |-rest_api_test.dart             ---> define test rest api script
test_driver/                       ---> place integration testing
  |-app.dart                       ---> define application bootstrap for integration testing
  |-app_test.dart                  ---> define integration test script
```
## Versioning
```
version: 1.0.1+202101001
---
Version name: 1.0.1
Version code: 202101001
```

Version name: major.minor.build
Version code: yyyymm<build number from 000>

* Remember to increase bold the version name and code as well.
## Multi env
- Create a new env factory in app_config.dart.
- Create a new file called main_<env>.dart. Ex: main_prod.dart and config to prod env
- Build with specific env
```
# default as dev
flutter build ios

# prod
flutter build ios -t lib/main_prod.dart
```

## Testing
- Unit test: https://flutter.dev/docs/cookbook/testing/unit/introduction
```
flutter test

# Test and export coverage information
# output to coverage/lcov.info
flutter test --coverage

# Convert to html
## Install lcov tool to convert lcov.info file to HTML pages
- Installing in Ubuntu:
sudo apt-get update -qq -y
sudo apt-get install lcov -y
- Installing in Mac:
brew install lcov

- Gen html files
genhtml coverage/lcov.info -o coverage/html

# Open in the default browser (mac):
open coverage/html/index.html

```
- Integration test: https://flutter.dev/docs/cookbook/testing/integration/introduction
```
flutter drive --target=test_driver/app.dart
```

## Optimize First Run performance

https://flutter.dev/docs/perf/rendering/shader

- On Android, “first run” means that the user might see jank the first time opening the app after a fresh installation. Subsequent runs should be fine.
- On iOS, “first run” means that the user might see jank when an animation first occurs every time the user opens the app from scratch.

How to use SkSL warmup?

```
1. Run the app with --cache-sksl turned on to capture shaders in SkSL
flutter run --profile --cache-sksl --purge-persistent-cache

2. Play with the app to trigger as many animations as needed; particularly those with compilation jank.

3. Press M at the command line of flutter run to write the captured SkSL shaders into a file named something like flutter_01.sksl.json. For best results, capture SkSL shaders on actual Android and iOS devices separately.

4. Build the app with SkSL warm-up using the following, as appropriate:
Android:
flutter build apk --bundle-sksl-path flutter_01.sksl.json
or
flutter build appbundle --bundle-sksl-path flutter_01.sksl.json

iOS:
flutter build ios --bundle-sksl-path flutter_01.sksl.json
```
## Integrate facebook/google/firebase key hash

### Gen new key store
```
keytool -genkey -v -keystore keystore-release.jks -alias KEY_ALIAS -keyalg RSA -keysize 2048 -validity 1000000 -storepass KEY_STORE_PASS -keypass KEY_PASS
```

### Get facebook key hashes
```
keytool -exportcert -alias androiddebugkey -keystore keystore-debug.jks | openssl sha1 -binary | openssl base64

=> enter storePassword

Ex: smKEjJWY1ZgwHQvuE3qGjwMC6jk=
```

### Get google/firebase key hash
```
keytool -exportcert -alias androiddebugkey -keystore keystore-debug.jks -list -v

=> enter storePassword

Alias name: androiddebugkey
Creation date: May 5, 2016
Entry type: PrivateKeyEntry
Certificate chain length: 1
Certificate[1]:
Owner: C=US, O=Android, CN=Android Debug
Issuer: C=US, O=Android, CN=Android Debug
Serial number: 1
Valid from: Thu May 05 15:32:50 ICT 2016 until: Sat Apr 28 15:32:50 ICT 2046
Certificate fingerprints:
     MD5:  8E:B3:66:00:35:D9:88:80:D5:DC:84:F9:2A:AE:0B:98
     SHA1: B2:62:84:8C:95:98:ED:98:30:1D:0B:EE:2F:CA:86:8F:03:02:E9:D9
     SHA256: 45:ED:59:3D:6F:41:F8:5F:04:45:FC:7D:AD:77:1A:9B:B4:33:43:27:F4:30:92:10:8E:07:D9:E9:AA:6F:8B:9C
     Signature algorithm name: SHA1withRSA
     Version: 1
```

### Deal with signed apk on google play store. 
```
It enables if Google Play App Signing, key hash from local release keystore file just use for upload to store, new key hash will be generated after upload and it’s a final key hash for distribution. 

Go to Play store -> Release management -> App signing -> Get SHA-1 certificate fingerprint from App signing certificate block as show in this image.

(Select App -> Release -> Setup -> App integrity for new play console)
```
#### Convert SHA-1 to facebook key hash
```
echo <SHA-1 HEX> | xxd -r -p | openssl base64

ex: 
echo B2:62:84:8C:95:98:ED:98:30:1D:0B:EE:2F:CA:86:8F:03:02:E9:D9 | xxd -r -p | openssl base64
```

## Release and publish to store

### Android 

- Docs: https://flutter.dev/docs/deployment/android
- Prepare release keystore:
- Create `android/key.properties`
    
```
keyAlias=
keyPassword=
storePassword=
storeFile=keystores/keystore-release.jks

#KEY INFO
#CN(first and last name): 
#OU(organizational unit): 
#O(organization): 
#L(City or Locality): 
#ST(State or Province): 
#C(country code): 
```
 
- Create `android/app/keystores/keystore-release.jks`
```
cd android/app/keystores/
export keyAlias=
export keyPassword=
export storePassword=
keytool -genkey -v -keystore keystore-release.jks -alias $keyAlias -keyalg RSA -keysize 2048 -validity 1000000 -storepass $storePassword -keypass $keyPassword
```

- Build release binary. There 2 type of binary app bundle with optimized size when download from Store and apk type.

+ To build apk
```
flutter build apk
```
+ To build app bundle
```
flutter build appbundle
```

* Get binary from the path which displayed in console after build successfully.

### iOS

- Docs: https://flutter.dev/docs/deployment/ios
- Create certs to build on `https://developer.apple.com`
    + Create app identity
    + Create certification for app
    + Create provision profile point to app identity and certification
- Create application on `https://appstoreconnect.apple.com`
- Build dart files first, at project root level
```
flutter build ios
```
- Build native application on Xcode -> Select build target to `Any iOS devices` -> Select `Product` -> `Archive` -> Upload to Store

------------------------------
