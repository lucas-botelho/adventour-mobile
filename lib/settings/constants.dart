class AppSettings {
  static const String apiBaseUrl = 'http://10.0.2.2:8080/api';
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
}

class Files {
  static const String controller = 'files';
  static const String upload = "$controller/upload";
}
