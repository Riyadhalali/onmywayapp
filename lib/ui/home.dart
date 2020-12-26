import 'package:alatareekeh/services/getprovdiedservices.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:alatareekeh/ui/home/searchfield.dart';
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
    //print(providedServicesList);
    return providedServicesList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // to delete back button
        title: Row(
          children: [
            SearchField(),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.directions_car),
            onPressed: () {
              // go to page seek service
            },
          ),
          SizedBox(
            width: 5.0.w,
          ),
        ],
      ),
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
                setState(() {});
                print(index);
              },
              title: Text(list.userName),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(list.servicePickup + " - " + list.serviceDestination),
                  Text(list.serviceDate),
                  Text(list.serviceGender),
                  Text(list.serviceSpace)
                ],
              ),
              trailing: RaisedButton(
                onPressed: () {
                  print('button is pressed');
                },
                child: Text("حجز"),
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
