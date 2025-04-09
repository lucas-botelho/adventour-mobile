class AppSettings {
  static const String apiBaseUrl = 'http://10.0.2.2/deisi2056/api';
}

class Authentication {
  static const String controller = 'authentication';
  // static const String test = "$controller/test";
  static const String user = "$controller/user";
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
}

class Files {
  static const String controller = 'files';
  static const String upload = "$controller/upload";
}
