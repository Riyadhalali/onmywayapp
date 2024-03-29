import 'package:alatareekeh/constants/colors.dart';
import 'package:alatareekeh/provider/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ToggleButtonpersonPackage extends StatefulWidget {
  //Function function;
  String imageAssetFirst;
  String imageAssetSecond;
  ToggleButtonpersonPackage(this.imageAssetFirst, this.imageAssetSecond);

  // ToggleButton({this.function});
//TODO: using provider when user select choice to update the selection
  @override
  State<ToggleButtonpersonPackage> createState() => _ToggleButtonpersonPackageState();
}

class _ToggleButtonpersonPackageState extends State<ToggleButtonpersonPackage> {
  ColorsApp colorsApp = new ColorsApp();
  bool changeColor = false;
  List<bool> isSelected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSelected = [false, false];
  }

  @override
  Widget build(BuildContext context) {
    Global globalProviders = Provider.of<Global>(context, listen: false);
    return ToggleButtons(
      borderRadius: BorderRadius.circular(50),
      fillColor: Colors.transparent, // to delete the blue color around the selection
      borderWidth: 2,
      renderBorder: true, // to delete the border around the toggle buttons
      selectedColor: colorsApp.selectedColor,
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
            if (buttonIndex == index) {
              // we get 1
              isSelected[buttonIndex] = true;
              changeColor = true;
            } else {
              // we get zero
              isSelected[buttonIndex] = false;
              changeColor = false;
            }
          }
          globalProviders.changeIndexToggleButtonPersonPackage(index);
          //  print(index);
        });
      },
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            child: Column(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // to make the selection circular
                    color: (!changeColor) ? colorsApp.selectedColor : Colors.white,
                    image: DecorationImage(
                      image: AssetImage(widget.imageAssetFirst),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
              child: Column(
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), // to make the selection circular
                  color: (changeColor) ? colorsApp.selectedColor : Colors.white,
                  image: DecorationImage(
                    image: AssetImage(widget.imageAssetSecond),
                  ),
                ),
              ),
            ],
          )),
        ),
      ],
      isSelected: isSelected,
    );
  }
}
