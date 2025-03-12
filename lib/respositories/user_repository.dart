import 'package:adventour/models/responses/auth/user.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:adventour/settings/constants.dart';

class UserRepository {
  Future<UserResponse?> getUserData() async {
    final firebaseAuthService = FirebaseAuthService();
    final apiService = ApiService();

    var firebaseUser = firebaseAuthService.getUser();

    if (firebaseUser != null) {
      var response = await apiService.get(
        Authentication.me,
        await firebaseAuthService.getIdToken(),
        headers: {},
        fromJsonT: (json) => UserResponse.fromJson(json),
      );

      return response.data;
    }

    return null;
  }

  String getUserInitial(UserResponse? user) =>
      user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : "?";
}
