import 'package:fimber/fimber.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:rxdart/rxdart.dart';

class DeepLinksManager {
  String _linkPrefix = '';
  String _uriPrefix = '';
  String _androidPackageName = '';
  String _bundleId = '';
  String _appStoreId = '';

  final BehaviorSubject<PendingDynamicLinkData?> _deepLinks = BehaviorSubject<PendingDynamicLinkData?>.seeded(null);
  final BehaviorSubject<String?> _errors = BehaviorSubject<String?>.seeded(null);

  Stream<PendingDynamicLinkData?> get deepLinks$ => _deepLinks.stream;
  Stream<String?> get errors$ => _errors.stream;

  Future<String> getDeepLinks(String link) async {
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse('$_linkPrefix$link'),
      uriPrefix: _uriPrefix,
      androidParameters: AndroidParameters(packageName: _androidPackageName),
      iosParameters: IOSParameters(bundleId: _bundleId, appStoreId: _appStoreId),
    );

    final Uri dynamicLink = await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);

    return dynamicLink.toString();
  }

  Future<void> init({
    required String linkPrefix,
    required String uriPrefix,
    required String androidPackageName,
    required String bundleId,
    required String appStoreId,
  }) async {
    _linkPrefix = linkPrefix;
    _uriPrefix = uriPrefix;
    _androidPackageName = androidPackageName;
    _bundleId = bundleId;
    _appStoreId = appStoreId;

    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData dynamicLinkData) {
      _deepLinks.add(dynamicLinkData);
    }).onError((Object? error) {
      _errors.add(error.toString());
      Fimber.d(error.toString());

      return;
    });
  }

  Future<void> openInitialLink() async {
    //Get any initial links
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      _deepLinks.add(initialLink);
    }
  }
}
