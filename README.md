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
