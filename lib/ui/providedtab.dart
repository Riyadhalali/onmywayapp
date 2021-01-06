import 'package:alatareekeh/services/getmyservices.dart';
import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProvidedTab extends StatefulWidget {
  ProvidedTab({Key key});
  static const id = 'provided_tab';
  @override
  _ProvidedTabState createState() => _ProvidedTabState();
}

class _ProvidedTabState extends State<ProvidedTab> {
  List<GetMyServices> getMyServices;
  String user_Id;
  SharedPref sharedPref = SharedPref();

  //------------------------------Functions-------------------------------------
  //->
  Future<List<GetMyServices>> fetchSeekedServices() async {
    user_Id = await sharedPref.LoadData('userID');
    getMyServices =
        await WebServices.Get_My_Services(user_Id, '1'); // two is for provided
    return getMyServices;
  }

  //----------------------------------------------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
} // end class