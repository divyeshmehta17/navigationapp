import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get_storage/get_storage.dart';

import 'enigma.dart';

class GetStorageService extends GetxService {
  static final _runData = GetStorage('runData');
  static final _appstorage = GetStorage("appstorage"); // Static instance
  final String googleApiKey = 'AIzaSyBO4WzyVucman3AU5D51ox2PP7cpn3FPzY';

  bool get getisCreator => _runData.read('isCreator') ?? false;
  set setisCreator(bool val) => _runData.write('isCreator', val);

  Future<GetStorageService> initState() async {
    await GetStorage.init('runData');
    await GetStorage.init('appstorage');
    return this;
  }

  Future<void> save(String key, dynamic value) async {
    try {
      await _appstorage.write(key, value);
      print('Data saved under $key');
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  String get getEncjwToken =>
      decryptAESCryptoJS(_runData.read('jwToken') ?? '') ?? '';
  set setEncjwToken(String val) =>
      _runData.write('jwToken', encryptAESCryptoJS(val));

  String? get deviceToken => _appstorage.read('deviceToken');
  set deviceToken(String? token) => _appstorage.write('deviceToken', token);

  set userLoggedIn(bool status) => _appstorage.write("status", status);
  bool get userLoggedIn => _appstorage.read("status") ?? false;

  void logout() {
    _runData.erase();
    _appstorage.erase();
  }

  // Access static _appstorage directly through the class
  static GetStorage get appstorage => _appstorage;
}
