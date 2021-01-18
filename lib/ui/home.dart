import 'package:alatareekeh/services/getprovdiedservices.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:alatareekeh/ui/addappointment.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
/*
this page is for provided services
*/

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GetProvidedServices> providedServicesList;

  Future<List<GetProvidedServices>> fetchList() async {
    providedServicesList = await WebServices.Get_Provided_Services();

    return providedServicesList;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: AppBar(
      //   //automaticallyImplyLeading: false, // to delete back button
      //   title: Text('provided'.tr().toString()),
      // ),
      body: FutureBuilder(
        future: fetchList(),
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
                  onRefresh: fetchList,
                  child: ProvidedServicesList(),
                );
          }
        },
      ),
    );
  } // end build

//--------------------------Provided Service List-------------------------------
  Widget ProvidedServicesList() {
    return Container(
      child: ListView.builder(
        itemCount: providedServicesList.length,
        itemBuilder: (context, index) {
          GetProvidedServices list = providedServicesList[index];
          return Card(
            child: ListTile(
              isThreeLine: false,
              onTap: () {
                // print(list.userId);
              },
              title: Text(
                list.userName,
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0.sp,
                    fontStyle: FontStyle.italic),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(list.servicePickup.toString() +
                      " - " +
                      list.serviceDestination.toString()),
                  Text(list.serviceDate),
                  Text(list.serviceGender.toString()),
                  Text('space'.tr().toString() + ': ' + list.serviceSpace)
                ],
              ),
              trailing: OutlineButton(
                color: Colors.blue,
                onPressed: () {
                  // go to Add Appointment page and pass params
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddAppointment(
                        providerUsername: list.userName,
                        providerID: list.userId.toString(),
                        providerPhone: list.userPhone.toString(),
                        providerGender: list.serviceGender.toString(),
                        providerSpace: list.serviceSpace,
                        date: list.serviceDate,
                        providerPickup: list.servicePickup.toString(),
                        providerDistination: list.serviceDestination.toString(),
                        providerServiceId: list.serviceId.toString(),
                      ),
                    ),
                  );
                },
                child: Text(
                  'addAppointment'.tr().toString(),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
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
