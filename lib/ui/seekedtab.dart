import 'package:alatareekeh/services/getmyservices.dart';
import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SeekedTab extends StatefulWidget {
  static const id = 'seeked_tab';
  @override
  _SeekedTabState createState() => _SeekedTabState();
}

class _SeekedTabState extends State<SeekedTab> {
  List<GetMyServices> getMyServices;
  String user_Id;
  SharedPref sharedPref = SharedPref();

  //------------------------------Functions-------------------------------------
  //->
  Future<List<GetMyServices>> fetchSeekedServices() async {
    getMyServices =
        await WebServices.Get_My_Services(user_Id, '2'); // two is for seeked
    return getMyServices;
  }

  //-> Load User id from shared pref
  void LoadUserData() async {
    user_Id = await sharedPref.LoadData('userID');
  }

  //----------------------------------------------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureMethod(),
    );
  } // end build

//-------------------------Future Method----------------------------------------
  Widget FutureMethod() {
    return FutureBuilder(
      future: fetchSeekedServices(), // any future function
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: new CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return RefreshIndicator(
                onRefresh: fetchSeekedServices,
                child: MySeekedServices(),
              );
        }
      },
    );
  }

  //----------------------------Seeked Servie Body------------------------------
  Widget MySeekedServices() {
    return Container(
      child: ListView.builder(
        itemCount: getMyServices.length,
        itemBuilder: (context, index) {
          GetMyServices list = getMyServices[index];
          return Card(
            child: ListTile(
              isThreeLine: false,
              onTap: () {
                // print(list.providerId);
              },
              // title: Text(list.providerName),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'serviceid'.tr().toString() + list.serviceId.toString(),
                  ),
                  Text(
                    'servicestatus'.tr().toString() +
                        list.serviceStatus.toString(),
                  ),
                  Text('servicepickup'.tr().toString() +
                      list.servicePickup.toString()),
                  Text(
                    'servicedestination'.tr().toString() +
                        list.serviceDestination.toString(),
                  ),
                  Text(
                    'servicedate'.tr().toString() + list.serviceDate.toString(),
                  ),
                  Text('servicespace'.tr().toString() + list.serviceSpace),
                ],
              ),
            ),
            borderOnForeground: true,
          );
        },
      ),
    );
  }

//------------------------------------------------------------------------------
} //end class
