import 'package:adventour/models/base_api_response.dart';
import 'package:adventour/models/requests/attraction/add_favorite.dart';
import 'package:adventour/models/responses/attraction/attraction_info_data_response.dart';
import 'package:adventour/models/responses/attraction/attraction_response.dart';
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

  Future<BaseApiResponse<AttractionResponse>?> getAttraction(int id) async {
    return await ApiService().get(
      '${Attraction.attraction}/$id',
      await FirebaseAuthService().getIdToken(),
      headers: <String, String>{},
      fromJsonT: (json) => AttractionResponse.fromJson(json),
    );
  }

  Future<BaseApiResponse<AttractionInfoDataResponse>?> getAttractionInfo(
      int id) async {
    return await ApiService().get(
      '${Attraction.attractionInfo}/$id',
      await FirebaseAuthService().getIdToken(),
      headers: <String, String>{},
      fromJsonT: (json) => AttractionInfoDataResponse.fromJson(json),
    );
  }

  Future<BaseApiResponse<String>?> createReview({required int attractionId, required String review, required String title, required int rating, required List<String>? imagesUrls}) async {
    var response = await UserRepository().getUserData();
    if (response == null) {
      return null;
    }

    return ApiService().post(
      endpoint: "${Attraction.createReview}/$attractionId",
      token: await firebaseAuthService.getIdToken(),
      headers: <String, String>{},
      body: {
        'oAuthId': response.data!.oauthId,
        'review': review,
        'title': title,
        'rating': rating,
        'imagesUrls': imagesUrls,
      },
      fromJsonT: (json) => json as String,
    );
  }
}
