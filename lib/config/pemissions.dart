import 'package:permission_handler/permission_handler.dart';

class permissionsHelper {
  /// Is "location always" permission granted?
  Future<bool> isLocationAlwaysGranted() async =>
      await Permission.locationAlways.isGranted;

/// Tries to ask for "location always" permissions from the user.
/// Returns `true` if successful, `false` othervise.
}
