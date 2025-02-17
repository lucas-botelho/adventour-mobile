class AppSettings {
  static const String apiBaseUrl = 'http://10.0.2.2:8080/api';
}

class Authentication {
  static const String controller = 'authentication';
  static const String test = "$controller/test";
  static const String register = "$controller/user";
}

class Country {
  static const String controller = 'country';
  static const String GetCountry = "$controller/country";
}

class Files {
  static const String controller = 'files';
  static const String upload = "$controller/upload";
}
