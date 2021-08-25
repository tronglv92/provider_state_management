import 'package:provider_state_management/my_app.dart';
import 'package:provider_state_management/utils/app_config.dart';
import 'package:provider_state_management/utils/app_theme.dart';

Future<void> main() async {
  /// Init dev config
  AppConfig(env: Env.dev(), theme: AppTheme.origin());
  await myMain();
}
