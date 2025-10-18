import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'main.dart';
import 'ProfilePage.dart';

class DataRepository{

  static String login = "";
  static String password = "";
  //static String _fname = "";
  //static String _lname = "";
  //static String _phone = "";
  //static String _email = "";

  void loadData() {
    //asynchronous from first page
    //load EncryptedSharedPreferences
  }

  void saveData() {
    //save EncryptedSharedPreferences

    //final prefs = await EncryptedSharedPreferences();

    //await prefs.setString("MySavedFirstName", _fname.text);
    //await prefs.setString("MySavedLastName", _lname.text);
    //await prefs.setString("MySavedPhoneNumber", _phone.text);
    //await prefs.setString("MySavedEmail", _email.text);

  }
}