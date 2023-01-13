import 'package:shared_preferences/shared_preferences.dart';

bool userLogged = false;
String? userLoggedStoreID;
String? userLoggedCourierID;

class Auth {
  checkUserSigned() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final logged = prefs.getBool('logged') ?? false;
    final storeId = prefs.getString('storeId');
    final courierId = prefs.getString('courierId');
    if (logged == true) {
      userLoggedCourierID = courierId;
      userLoggedStoreID = storeId;
      userLogged = true;
    } else {
      userLogged = false;
    }
  }

  Future keepUserLoggedIn(
      {required String storeID, required String courierId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('logged', true);
    prefs.setString('storeId', storeID);
    prefs.setString('courierId', courierId);
  }

  Future signUserOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('logged', false);
    prefs.setString('storeId', null.toString());
    prefs.setString('courierId', null.toString());
  }
}
