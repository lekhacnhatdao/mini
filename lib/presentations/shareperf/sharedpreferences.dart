import 'package:shared_preferences/shared_preferences.dart';

class Preferncent{
  static  late SharedPreferences  sharedPreferences;
  static const key ='data';
  static Future init() async =>
  sharedPreferences = await SharedPreferences.getInstance();
  static Future setBool(bool data) async =>
  await sharedPreferences.setBool(key, data);
  static bool getListString()   =>
   sharedPreferences.getBool(key) ?? false ;
}