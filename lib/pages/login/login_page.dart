import 'package:flutter/material.dart';
import 'package:provider_state_management/models/remote/login_response.dart';
import 'package:provider_state_management/pages/login/login_provider.dart';
import 'package:provider_state_management/services/app/app_dialog.dart';
import 'package:provider_state_management/services/app/app_loading.dart';
import 'package:provider_state_management/services/rest_api/api_error.dart';
import 'package:provider_state_management/services/rest_api/api_error_type.dart';
import 'package:provider_state_management/services/safety/page_stateful.dart';
import 'package:provider_state_management/utils/app_extension.dart';
import 'package:provider_state_management/utils/app_helper.dart';
import 'package:provider_state_management/utils/app_log.dart';
import 'package:provider_state_management/utils/app_route.dart';
import 'package:provider_state_management/widgets/p_appbar_transparency.dart';
import 'package:provider_state_management/widgets/w_env.dart';
import 'package:provider_state_management/widgets/w_input_form.dart';
import 'package:provider_state_management/widgets/w_keyboard_dismiss.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends PageStateful<LoginPage> with WidgetsBindingObserver, ApiError {
  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  LoginProvider loginProvider;

  @override
  void initDependencies(BuildContext context) {
    super.initDependencies(context);
    loginProvider = Provider.of(context, listen: false);
  }

  @override
  void afterFirstBuild(BuildContext context) {
    loginProvider.resetState();

    /// Init email focus
    /// autofocus in TextField has an issue on next keyboard button
    _idFocusNode.requestFocus();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Log app life cycle state
    logger.d(state);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PAppBarTransparency(
      child: WKeyboardDismiss(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.W),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SafeArea(
                  child: WEnv(),
                ),

                /// Logo
                Padding(
                  padding: EdgeInsets.only(top: 100.H, bottom: 50.H),
                  child: Image.asset(appTheme.assets.icAppIcon, width: 150, height: 150),
                ),

                /// Login form
                /// Email + password
                WInputForm.number(
                  key: const Key('idInputKey'),
                  labelText: context.strings.labelID,
                  onChanged: loginProvider.onIDChangeToValidateForm,
                  focusNode: _idFocusNode,
                  textInputAction: TextInputAction.next,

                  onSubmitted: (String term) {
                    AppHelper.nextFocus(context, _idFocusNode, _passwordFocusNode);
                  },
                ),
                SizedBox(height: 20.H),
                Selector<LoginProvider, bool>(
                  selector: (_, LoginProvider provider) => provider.obscureText,
                  builder: (_, bool obscureText, __) {
                    return WInputForm.password(
                      key: const Key('passwordInputKey'),
                      labelText: context.strings.labelPassword,
                      suffixIcon: IconButton(
                        icon: obscureText ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                        onPressed: () {
                          loginProvider.obscureText = !loginProvider.obscureText;
                        },
                      ),
                      obscureText: obscureText,
                      onChanged: loginProvider.onPasswordChangeToValidateForm,
                      focusNode: _passwordFocusNode,
                      textInputAction: TextInputAction.done,
                    );
                  },
                ),
                SizedBox(height: 30.H),

                /// Example call api with success response
                ElevatedButton(
                  key: const Key('callApiBtnKey'),
                  onPressed: context.select((LoginProvider provider) => provider.formValid)
                      ? () async {
                    print("loginProvider.idValue "+loginProvider.idValue.toString());
                    print("loginProvider.passwordValue "+loginProvider.passwordValue.toString());
                          final bool success = await apiCallSafety(
                            () => authProvider.login(loginProvider.idValue, loginProvider.passwordValue),
                            onStart: () async {
                              AppLoading.show(context);
                            },
                            onCompleted: (bool status, bool res) async {
                              AppLoading.hide(context);
                            },
                            onError: (dynamic error) async {
                              final ApiErrorType errorType = parseApiErrorType(error);
                              print("errorType.message "+errorType.message.toString());
                              AppDialog.show(
                                context,
                                errorType.message,
                                title: 'Error',
                              );
                            },
                            skipOnError: true,
                          );
                          if (success == true) {
                            context.navigator()?.pushReplacementNamed(AppRoute.routeHome);
                          }
                        }
                      : null,
                  child: Text(context.strings.btnLogin),
                ),



                SizedBox(height: 30.H),

                /// Login button
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Future<int> onApiError(dynamic error) async {
    final ApiErrorType errorType = parseApiErrorType(error);
    await AppDialog.show(context, errorType.message);
    return 0;
  }
}
