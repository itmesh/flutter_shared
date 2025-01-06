// import 'package:mixpanel_flutter/mixpanel_flutter.dart';

// class ItmMixpanel extends Mixpanel {
//   ItmMixpanel(super.token);

//   /// The EU server URL for Mixpanel.
//   static const String _serverURL = 'https://api-eu.mixpanel.com';

//   static Future<Mixpanel> init(String token) async {
//     final Mixpanel mixpanel = await Mixpanel.init(
//       token,
//       trackAutomaticEvents: true,
//     );

//     // !-- IMPORTANT --!
//     // This must NEVER be removed.
//     // It ensures that all data is kept within the EU
//     // and that the tracking is GDPR compliant.
//     mixpanel.setServerURL(_serverURL);

//     return mixpanel;
//   }
// }
