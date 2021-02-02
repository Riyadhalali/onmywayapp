import 'package:alatareekeh/services/getprovdiedservices.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:alatareekeh/ui/addappointment.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
/*
this page is for provided services
*/

/*
best practicle is to how to use  the refresh indicator is like this:
1- when we call the  set state is will call the initstate function so for
refreshing when user swip down we call inside the refresh indicator function
just setstate function for updating widget and because the set state will update the
build and call the init state we call the fetchuser


 */

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
//{
  //----------------------------------------------------------------------------
  DateTime
      currentBackPressButton; // varaiable to hold the date and time for exit button

  int counter = 0;
  bool keepAlive = true;
  Future myFuture; // if we want the future to build just one
  List<GetProvidedServices> providedServicesList;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
//------------------------------fetch List--------------------------------------
  Future<List<GetProvidedServices>> fetchList() async {
    providedServicesList = await WebServices.Get_Provided_Services();

    return providedServicesList;
  }

//------------------------------POP Screen--------------------------------------
  Future<bool> onExitButton() {
    DateTime now = DateTime.now();
    if (currentBackPressButton == null ||
        now.difference(currentBackPressButton) > Duration(seconds: 2)) {
      currentBackPressButton = now;
      Fluttertoast.showToast(
          msg: "exit_warning".tr().toString(),
          backgroundColor: Colors.white,
          textColor: Colors.black);
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(true); // to exit program
  }
  //----------------------------------------------------------------------------

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => keepAlive;
  @override
  void initState() {
    // TODO: implement initState
    ///  myFuture = fetchList(); // if we want the future builds just one

    super.initState();
    fetchList();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: onExitButton,
        child: FutureBuilder(
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
                    key: _refreshIndicatorKey,
                    onRefresh: () async {
                      setState(() {
                        return true;
                      });
                    },
                    child: ProvidedServicesList(),
                  );
            }
          },
        ),
      ),
    );
  } // end build

//--------------------------Provided Service List-------------------------------
  Widget ProvidedServicesList() {
    return Container(
      child: providedServicesList.isEmpty
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
              itemCount: providedServicesList.length,
              itemBuilder: (context, index) {
                GetProvidedServices list = providedServicesList[index];
                return Card(
                  child: ListTile(
                    isThreeLine: false,
                    onTap: () {},
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
                              providerDistination:
                                  list.serviceDestination.toString(),
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
//done
