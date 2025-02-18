class PatchUserPublicDataResponse {
  final bool updated;

  PatchUserPublicDataResponse({this.updated = false});

  factory PatchUserPublicDataResponse.fromJson(Map<String, dynamic> json) {
    return PatchUserPublicDataResponse(
      updated: json['updated'],
    );
  }
}
