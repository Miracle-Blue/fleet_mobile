part of '../main_screen_state.dart';

mixin MainScreenPermissionMixin on State<MainScreen> {
  Future<PermissionResponse?> onPermissionRequest(_, PermissionRequest permissionRequest) async =>
      PermissionResponse(resources: permissionRequest.resources, action: PermissionResponseAction.GRANT);
}
