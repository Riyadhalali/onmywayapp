import 'package:alatareekeh/services/GetSearchResults.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:alatareekeh/ui/addappointment.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchResults extends StatefulWidget {
  static const id = 'search_results';

  final String serviceType;
  final String from;
  final String to;
  final String gender;
  final String date;

  SearchResults({this.serviceType, this.from, this.to, this.gender, this.date});
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  List<GetSearchResults> searchResultsList;
  //-----------------------------Get Search Results-----------------------------
  Future<List<GetSearchResults>> fetchsearchresults() async {
    searchResultsList = await WebServices.Search_Services(
        widget.serviceType, widget.from, widget.to, widget.gender, widget.date);
    return searchResultsList;
  }
//------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('searchresults'.tr().toString()),
      ),
      body: FutureMethod(),
    );
  }

//-------------------------Future Method----------------------------------------
  Widget FutureMethod() {
    return FutureBuilder(
      future: fetchsearchresults(), // any future function
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: new CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return MySearchResults();
        }
      },
    );
  }

  //----------------------------My Search Results-------------------------------
  Widget MySearchResults() {
    return Container(
      child: ListView.builder(
        itemCount: searchResultsList.length,
        itemBuilder: (context, index) {
          GetSearchResults list = searchResultsList[index];
          return Card(
            child: ListTile(
              isThreeLine: false,
              onTap: () {
                print(list.userId);
              },
              title: Text(list.userName),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(list.servicePickup.toString() +
                      " - " +
                      list.serviceDestination.toString()),
                  Text(list.serviceDate),
                  Text(list.serviceGender.toString()),
                  Text(list.serviceSpace)
                ],
              ),
              trailing: RaisedButton(
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
                child: Text('addAppointment'.tr().toString()),
              ),
            ),
            borderOnForeground: true,
          );
        },
      ),
    );
  }

  //----------------------------------------------------------------------------
}
