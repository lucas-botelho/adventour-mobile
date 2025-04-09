import 'package:adventour/models/base_api_response.dart';
import 'package:adventour/models/responses/attraction/basic_attraction_list_response.dart';
import 'package:adventour/services/api_service.dart';
import 'package:adventour/services/firebase_auth_service.dart';
import 'package:adventour/settings/constants.dart';

class AttractionRespository {
  final apiService = ApiService();
  final firebaseAuthService = FirebaseAuthService();

  Future<BaseApiResponse<BasicAttractionListResponse>?> getAttractions({
    required String countryCode,
  }) async {
    final result = await ApiService().get(
      '${Country.listAttractions}?countryCode=$countryCode',
      await FirebaseAuthService().getIdToken(),
      headers: <String, String>{},
      fromJsonT: (json) => BasicAttractionListResponse.fromJson(json),
    );

    return result;
  }
}
