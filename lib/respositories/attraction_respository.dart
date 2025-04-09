import 'package:adventour/models/base_api_response.dart';
import 'package:adventour/models/requests/attraction/add_favorite.dart';
import 'package:adventour/models/responses/attraction/basic_attraction_list_response.dart';
import 'package:adventour/respositories/user_repository.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:adventour/settings/constants.dart';

class AttractionRespository {
  final apiService = ApiService();
  final firebaseAuthService = FirebaseAuthService();

  Future<BaseApiResponse<BasicAttractionListResponse>?> getAttractions({
    required String countryCode,
  }) async {
    var user = await UserRepository().getUserData();

    if (user == null) {
      return null;
    }

    final result = await ApiService().get(
      '${Attraction.listAttractions}?countryCode=$countryCode&oAuthId=${user.data?.oauthId}',
      await FirebaseAuthService().getIdToken(),
      headers: <String, String>{},
      fromJsonT: (json) => BasicAttractionListResponse.fromJson(json),
    );

    return result;
  }

  Future<BaseApiResponse<String>?> addToFavorite(
    int attractionId,
  ) async {
    var response = await UserRepository().getUserData();
    if (response == null) {
      return null;
    }

    final result = await ApiService().post(
      endpoint: '${Attraction.addToFavorites}?attractionId=$attractionId',
      token: await FirebaseAuthService().getIdToken(),
      headers: <String, String>{},
      body: ToggleFavoriteRequest(
              attractionId: attractionId, userId: response.data!.oauthId)
          .toJson(),
      fromJsonT: (json) => json as String,
    );

    return result;
  }

  Future<BaseApiResponse<String>?> removeFromFavorite(int attractionId) async {
    var response = await UserRepository().getUserData();
    if (response == null) {
      return null;
    }

    return await ApiService().post(
      endpoint: Attraction.removeFavorite,
      token: await firebaseAuthService.getIdToken(),
      headers: <String, String>{},
      body: ToggleFavoriteRequest(
              attractionId: attractionId, userId: response.data!.oauthId)
          .toJson(),
      fromJsonT: (json) => json as String,
    );
  }
}
