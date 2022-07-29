import 'package:pgi_mobile/models/log.dart';
import 'package:pgi_mobile/services/offline/database_helper.dart';
import 'package:pgi_mobile/utils/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypt/crypt.dart';

class Token {
  static const baseUrl = ApiUrl.baseUrl;
  String? email;
  String? password;
  dynamic userId;

  savePref(String token, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token);
    preferences.setString("user_id", id);
  }

  saveUserCredential(String email, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("email", email);
    preferences.setString("password", password);
  }

  /*encryptUserData(email, password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final data = await getKey();
    final key = Key.fromUtf8(data["key"]);
    final iv = IV.fromUtf8(data["iv"]);
    //used to encrypt data
    final encrypter = Encrypter(AES(key));
    //encrypt the email and the password
    final encryptedEmail = encrypter.encrypt(email, iv: iv);
    final encryptedPassword = encrypter.encrypt(password, iv: iv);
    //return data
    final datas = {
      "email": encryptedEmail.base64,
      "password": encryptedPassword.base64
    };
    preferences.setString("email", encryptedEmail.base64);
    preferences.setString("password", encryptedPassword.base64);
    print(datas);
    return datas;
  }*/
  encryptUserData(email, password) async {
    final hashedPassword = Crypt.sha256(password);
    final hashedEmail = Crypt.sha256(email);
    final data = {
      "email": hashedEmail.toString(),
      "password": hashedPassword.toString(),
    };
    return data;
  }

  /*decryptUserData(email, password) async {
    final data = await getKey();
    final key = Key.fromUtf8(data["key"]);
    final iv = IV.fromUtf8(data["iv"]);
    final encrypter = Encrypter(AES(key));

    final decryptedEmail =
        encrypter.decrypt(Encrypted.fromBase64(email!), iv: iv);
    final decryptedPassword =
        encrypter.decrypt(Encrypted.fromBase64(password!), iv: iv);
    print("email decrypted :" +
        decryptedEmail +
        " password decrypted :" +
        decryptedPassword);
    return {"email": decryptedEmail, "password": decryptedPassword};
  }*/

  checkUserOffline(emailCheck, passwordCheck) async {
    Provider provider = Provider();
    List<Log> log = await provider.getLastLogFromDB();
    for (var element in log) {
      email = element.email;
      password = element.password;
    }
    final encryptedEmail = Crypt(email!);
    final encryptedPassword = Crypt(password!);
    if (encryptedPassword.match(passwordCheck) &&
        encryptedEmail.match(emailCheck)) {
      return true;
    } else {
      return false;
    }
  }

  getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");
    return token;
  }
}
