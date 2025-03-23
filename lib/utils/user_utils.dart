import 'package:adventour/models/responses/auth/user.dart';

class UserUtils {
  String getUserInitial(UserResponse? user) =>
      user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : "?";
}
