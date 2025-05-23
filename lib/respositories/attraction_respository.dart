import 'package:adventour/models/base_api_response.dart';
import 'package:adventour/models/requests/attraction/add_favorite.dart';
import 'package:adventour/models/responses/attraction/attraction_info_data_response.dart';
import 'package:adventour/models/responses/attraction/attraction_response.dart';
import 'package:adventour/models/responses/attraction/attraction_reviews_response.dart';
import 'package:adventour/models/responses/attraction/basic_attraction_list_response.dart';
import 'package:adventour/models/responses/attraction/favorites_response.dart';
import 'package:adventour/respositories/user_repository.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:adventour/settings/constants.dart';

class AttractionRepository {
  final ApiService apiService;
  final FirebaseAuthService authService;
  final UserRepository userRepository;

  AttractionRepository(
      {required this.apiService,
      required this.authService,
      required this.userRepository});

  Future<BaseApiResponse<BasicAttractionListResponse>?> getAttractions({
    required String countryCode,
  }) async {
    var user = await userRepository.getUserData();

    if (user == null) {
      return null;
    }

    var token = await authService.getIdToken();

    final result = await apiService.get(
      '${Attraction.listAttractions}?countryCode=$countryCode&oAuthId=${user.data?.oauthId}',
      await authService.getIdToken(),
      headers: <String, String>{},
      fromJsonT: (json) => BasicAttractionListResponse.fromJson(json),
    );

    return result;
  }

  Future<BaseApiResponse<String>?> addToFavorite(
    int attractionId,
  ) async {
    var response = await userRepository.getUserData();
    if (response == null) {
      return null;
    }

    final result = await apiService.post(
      endpoint: '${Attraction.addToFavorites}?attractionId=$attractionId',
      token: await authService.getIdToken(),
      headers: <String, String>{},
      body: ToggleFavoriteRequest(
              attractionId: attractionId, userId: response.data!.oauthId)
          .toJson(),
      fromJsonT: (json) => json as String,
    );

    return result;
  }

  Future<BaseApiResponse<String>?> removeFromFavorite(int attractionId) async {
    var response = await userRepository.getUserData();
    if (response == null) {
      return null;
    }

    return await apiService.post(
      endpoint: Attraction.removeFavorite,
      token: await authService.getIdToken(),
      headers: <String, String>{},
      body: ToggleFavoriteRequest(
              attractionId: attractionId, userId: response.data!.oauthId)
          .toJson(),
      fromJsonT: (json) => json as String,
    );
  }

  Future<BaseApiResponse<AttractionResponse>?> getAttraction(int id) async {
    return await apiService.get(
      '${Attraction.attraction}/$id',
      await authService.getIdToken(),
      headers: <String, String>{},
      fromJsonT: (json) => AttractionResponse.fromJson(json),
    );
  }

  Future<BaseApiResponse<AttractionInfoDataResponse>?> getAttractionInfo(
      int id) async {
    return await apiService.get(
      '${Attraction.attractionInfo}/$id',
      await authService.getIdToken(),
      headers: <String, String>{},
      fromJsonT: (json) => AttractionInfoDataResponse.fromJson(json),
    );
  }

  Future<BaseApiResponse<String>?> createReview(
      {required int attractionId,
      required String review,
      required String title,
      required int rating,
      required List<String>? imagesUrls}) async {
    var response = await userRepository.getUserData();
    if (response == null) {
      return null;
    }

    return apiService.post(
      endpoint: "${Attraction.createReview}/$attractionId",
      token: await authService.getIdToken(),
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

  Future<BaseApiResponse<AttractionReviewsResponse>?> getReviews(
      {required int attractionId}) async {
    return apiService.get(
      "${Attraction.reviews}/$attractionId",
      await authService.getIdToken(),
      headers: <String, String>{},
      fromJsonT: (json) => AttractionReviewsResponse.fromJson(json),
    );
  }

  Future<BaseApiResponse<FavoritesResponse>?> getFavorites() async {
    return apiService.get(
        "${Attraction.favorites}",
      await authService.getIdToken(),
      headers: <String, String>{},
      fromJsonT: (json) => FavoritesResponse.fromJson(json),
    );
  }

  //todo: implement deleteReview
  // Future<BaseApiResponse<String>?> deleteReview(
  //     {required int reviewId}) async {
  //   return apiService.delete(
  //     "${Attraction.deleteReview}/$reviewId",
  //     await authService.getIdToken(),
  //     headers: <String, String>{},
  //     fromJsonT: (json) => json as String,
  //   );
  // }


}
