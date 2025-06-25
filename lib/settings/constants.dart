class AppSettings {
  static const String apiBaseUrl = 'http://adventour.duckdns.org:8080/api';
}

class Authentication {
  static const String controller = 'authentication';
  // static const String test = "$controller/test";
  static const String user = "$controller/user";
  static const String resendCodeEmail = "$controller/resend/confirmation";
  static const String confirmEmail = "$controller/email/confirm";
  static const String emailRegistred = "$controller/exist";
  static const String me = "$controller/user/me";
}

class Country {
  static const String controller = 'country';
  static const String getCountry = "$controller/country";
  static const String listCountries = "$controller/list/countries";
}

class Attraction {
  static const String controller = 'attraction';
  static const String listAttractions = "$controller/list/attractions";
  static const String addToFavorites = "$controller/favorite";
  static const String removeFavorite = "$controller/favorite/remove";
  static const String attraction = "$controller/attraction";
  static const String attractionInfo = "$controller/info";
  static const String createReview = "$controller/review";
  static const String reviews = "$controller/reviews";
  static const String favorites = "$controller/favorites";
}

class Files {
  static const String controller = 'files';
  static const String upload = "$controller/upload";
  static const String uploadMultiple = "$controller/upload/multiple";
}

class Itinerary {
  static const String controller = 'Itinerary';
  static const String itinerary = "$controller/itinerary";
}
