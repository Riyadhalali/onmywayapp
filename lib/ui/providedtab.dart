import 'package:alatareekeh/services/getmyservices.dart';
import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

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

  //--------------------------Show Processing Dialog------------------------------
  void showProcessingDialog() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            content: Container(
              width: 80.0.w,
              height: 15.0.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 5.0.w,
                ),
                Text("deleting".tr().toString(),
                    style: TextStyle(
                        fontFamily: "OpenSans", color: Color(0xFF5B6978)))
              ]),
            ),
          );
        });
  }

//--------------------------Delete Service--------------------------------------
  void deleteService(String serviceId, int index) async {
    var message;
    // popping the confirm dialog
    Navigator.of(context).pop();

    showProcessingDialog();

    message = await WebServices.Delete_Service(serviceId);

    setState(() {
      getMyServices.removeAt(
          index); // to delete the item that have been deleted from api call
    });

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
    Navigator.of(context).pop();
  }

  //----------------------------------------------------------------------------

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
      child: getMyServices.isEmpty
          ? Center(child: Text('noresultsfound'.tr().toString()))
          : ListView.builder(
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
                        // Text(
                        //   'serviceid'.tr().toString() + list.serviceId.toString(),
                        // ),
                        // Text(
                        //   'servicestatus'.tr().toString() +
                        //       list.serviceStatus.toString(),
                        // ),
                        Row(
                          children: [
                            Text(
                              'servicepickup'.tr().toString() +
                                  ': ' +
                                  list.servicePickup.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'servicedestination'.tr().toString() +
                                  ': ' +
                                  list.serviceDestination.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'servicedate'.tr().toString() +
                                    ': ' +
                                    list.serviceDate.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'servicespace'.tr().toString() +
                                  ': ' +
                                  list.serviceSpace,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 5,
                      children: [
                        IconButton(
                          onPressed: () {
                            return showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("delete".tr().toString()),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          Text('areyousure'.tr().toString())
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => deleteService(
                                          list.serviceId.toString(),
                                          index,
                                        ),
                                        child: Text("sure".tr().toString()),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // close the dialog
                                        },
                                        child: Text(
                                          'cancel'.tr().toString(),
                                        ),
                                      )
                                    ],
                                  );
                                });

                            // make get location of the id
                          },
                          icon: Icon(Icons.delete),
                        ),
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
//done
