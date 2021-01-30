import 'package:alatareekeh/services/getseekedservices.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:alatareekeh/ui/addappointment.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SeekedServices extends StatefulWidget {
  static const String id = 'seekedservices_page';

  //Customer is the user and Provider is how added the order
  final String providerUsername;
  final int providerID;
  final String providerPhone;
  final String providerGender;
  final String providerSpace;
  final String date;
  final String providerPickup;
  final String providerDistination;

  SeekedServices(
      {this.providerUsername,
      this.providerID,
      this.providerPhone,
      this.providerGender,
      this.providerSpace,
      this.date,
      this.providerPickup,
      this.providerDistination});
  @override
  _SeekedServicesState createState() => _SeekedServicesState();
}

class _SeekedServicesState extends State<SeekedServices>
    with AutomaticKeepAliveClientMixin {
  bool keepAlive = true;
  List<GetSeekedServices> seekedServicesList; // an  object of seeked services

//-> this method will get the data in async mode
  Future<List<GetSeekedServices>> fetchSeekedList() async {
    seekedServicesList = await WebServices
        .Get_Seeked_Services(); // this method used as static method

    return seekedServicesList;
  }

  //-------------------------------Keep Alive Function--------------------------

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => keepAlive;

  //-----------------------------Init State-------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSeekedList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureMethod(),
    );
  } // end build

//--------------------------------Future Method that will get the data----------
  Widget FutureMethod() {
    return FutureBuilder(
      future: fetchSeekedList(),
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
                onRefresh: () async {
                  setState(() {
                    return true; // return anything
                  });
                },
                child: SeekedServicesWidget(),
              );
        }
      },
    );
  }

//----------------------------------Widget Tree---------------------------------
  Widget SeekedServicesWidget() {
    return Container(
      child: seekedServicesList.isEmpty
          ? Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'noresultsfound'.tr().toString(),
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          return 0; // just for returning data
                        });
                      },
                      child: Text(
                        'retry'.tr().toString(),
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: seekedServicesList.length, // important
              itemBuilder: (context, index) {
                GetSeekedServices list = seekedServicesList[index];
                return Card(
                  child: ListTile(
                    onTap: () {},
                    title: Text(
                      list.userName,
                      style: TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              list.servicePickup.toString() +
                                  ' - ' +
                                  list.serviceDestination.toString(),
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'date'.tr().toString() +
                                    ': ' +
                                    list.serviceDate,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'gender'.tr().toString() +
                                  ': ' +
                                  list.serviceGender,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'space'.tr().toString() +
                                  ': ' +
                                  list.serviceSpace,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                    trailing: OutlineButton(
                      onPressed: () {
                        // go to Add Appointment page and pass params
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddAppointment(
                              providerUsername: list.userName,
                              providerID: list.userId,
                              providerPhone: list.userPhone,
                              providerGender: list.serviceGender,
                              providerSpace: list.serviceSpace,
                              date: list.serviceDate,
                              providerPickup: list.servicePickup,
                              providerDistination: list.serviceDestination,
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
                );
              },
            ),
    );
  }

//------------------------------------------------------------------------------

} // end class
//done
