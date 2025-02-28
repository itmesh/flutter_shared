// import 'package:flutter/material.dart';
// import 'package:mixpanel_flutter/mixpanel_flutter.dart';

// ///! --- IMPORTANT ---
// /// Doesn't work on macOS!
// class ItmAnalyticsMixpanel {
//   ItmAnalyticsMixpanel(Mixpanel itmMixpanel) : _mixpanel = itmMixpanel;

//   // region Values

//   /// The Mixpanel instance.
//   final Mixpanel _mixpanel;

//   // endregion

//   Future<void> identifyUser(String userId) async {
//     await _mixpanel.identify(userId);
//   }

//   Future<void> aliasExistingUser(String userId) async {
//     _mixpanel.alias(userId, await _mixpanel.getDistinctId());
//   }

//   Future<void> trackRoute(Route<dynamic> route) async {
//     await _mixpanel.track(route.settings.name ?? 'Unnamed route');
//   }

//   Future<void> registerSuperProperties(Map<String, dynamic> superProperties) async {
//     await _mixpanel.registerSuperProperties(superProperties);
//   }

//   Future<void> registerUserProperties(Map<String, dynamic> userProperties) async {
//     // Mixpanel does not distinguish between super and user properties.
//     await _mixpanel.registerSuperProperties(userProperties);
//   }

//   Future<void> clearSuperProperties() async {
//     //SuperProperties will persist even if your application is taken completely out of memory.
//     //to remove a superProperty, call unregisterSuperProperty() or clearSuperProperties()
//     //works only for mobile platforms
//     await _mixpanel.clearSuperProperties();
//   }

//   Future<void> track({
//     required String event,
//     required Map<String, dynamic> properties,
//   }) async {
//     await _mixpanel.track(
//       event,
//       properties: properties,
//     );
//   }
// }
