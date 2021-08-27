  import 'package:shared_preferences/shared_preferences.dart';

  class SharedPref {
  /*  final String key;
    final String data;
  // create constructor
    SharedPref(this.key, this.data);*/

    //-> function for saving strings
    setData(String key, String data) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString(key, data);
      //  print(key);
      //  print(data);
    }

    //-> function for loading data from shared preferences
    Future<String> LoadData(String key) async {
      var returned_data;
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      returned_data = sharedPreferences.getString(key);
      return returned_data;
    }
  } // end class
