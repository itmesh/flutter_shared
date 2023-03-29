import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:letsdanceshared/letsdanceshared.dart';

class DeepLinksManager {
  Future<String> getDeepLinks(String link) async {
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse('https://letsdanceapp.pl$link'),
      uriPrefix: 'https://letsdanceapp.page.link/',
      androidParameters: const AndroidParameters(packageName: 'com.itmesh.letsdance'),
      iosParameters: const IOSParameters(bundleId: 'com.letsdance.app', appStoreId: '1615947410'),
    );

    final Uri dynamicLink = await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);

    return dynamicLink.toString();
  }

  Future<void> initDeepLinks() async {
    //Deep links
    WidgetsFlutterBinding.ensureInitialized();

    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData dynamicLinkData) {
      ldRouter.pushNamed(dynamicLinkData.link.path);
    }).onError((Object? _) {
      ldRouter.pushNamed('/');
      return;
    });
  }

  Future<void> openDeepLink() async {
    //Get any initial links
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      // Example of using the dynamic link to push the user to a different screen
      ldRouter.pushNamed(deepLink.path);
    }
  }
}
