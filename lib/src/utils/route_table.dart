import 'package:flutter/widgets.dart';
import 'package:langdida_ui/src/features/settings/settings.dart';

enum RouteName {
  settings,
}

final Map<RouteName, WidgetBuilder> routes = {
  RouteName.settings: (context) => SettingsPage(key: UniqueKey()),
};
