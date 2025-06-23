import 'package:flutter/foundation.dart';

class GlobalAppState extends ChangeNotifier {
  String _continentName = '';
  String _countryIsoCode = '';

  String get continentName => _continentName;
  String get countryIsoCode => _countryIsoCode;

  void setContinentAndCountry(String continent, String isoCode) {
    _continentName = continent;
    _countryIsoCode = isoCode;
    notifyListeners();
  }

  void setContinent(String continent) {
    _continentName = continent;
    notifyListeners();
  }

  void setCountryIsoCode(String isoCode) {
    _countryIsoCode = isoCode;
    notifyListeners();
  }

  void clear() {
    _continentName = '';
    _countryIsoCode = '';
    notifyListeners();
  }
}
