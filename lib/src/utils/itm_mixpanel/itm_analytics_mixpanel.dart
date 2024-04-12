import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

///! --- IMPORTANT ---
/// Doesn't work on macOS!
class ItmAnalyticsMixpanel {
  ItmAnalyticsMixpanel(Mixpanel itmMixpanel) : _mixpanel = itmMixpanel;

  // region Values

  /// The Mixpanel instance.
  final Mixpanel _mixpanel;

  // endregion

  void identifyUser(String userId) async {
    _mixpanel.identify(userId);
  }

  void aliasExistingUser(String userId) async {
    _mixpanel.alias(userId, await _mixpanel.getDistinctId());
    _mixpanel.identify(userId);
  }

  void trackRoute(Route<dynamic> route) {
    _mixpanel.track(route.settings.name ?? 'Unnamed route');
  }

  void registerSuperProperties(Map<String, dynamic> superProperties) async {
    _mixpanel.registerSuperProperties(superProperties);
  }

  void registerUserProperties(Map<String, dynamic> userProperties) async {
    // Mixpanel does not distinguish between super and user properties.
    _mixpanel.registerSuperProperties(userProperties);
  }

  void track({
    required String event,
    required Map<String, dynamic> properties,
  }) async {
    _mixpanel.track(
      event,
      properties: properties,
    );
  }
}
