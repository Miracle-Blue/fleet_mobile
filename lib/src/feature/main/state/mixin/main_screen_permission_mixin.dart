part of '../../screen/main_screen.dart';

mixin MainScreenPermissionMixin on State<MainScreen> {
  Future<PermissionResponse?> onPermissionRequest(_, PermissionRequest permissionRequest) async =>
      PermissionResponse(resources: permissionRequest.resources, action: PermissionResponseAction.GRANT);
}
