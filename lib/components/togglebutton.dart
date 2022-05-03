import 'package:alatareekeh/constants/colors.dart';
import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  //Function function;

  // ToggleButton({this.function});

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  ColorsApp colorsApp = new ColorsApp();

  List<bool> isSelected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSelected = [false, false];
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderWidth: 0,
      renderBorder: false, // to delete the border around the toggle buttons
      selectedColor: colorsApp.selectedColor,
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
            if (buttonIndex == index) {
              // we get 1
              isSelected[buttonIndex] = true;
            } else {
              // we get zero
              isSelected[buttonIndex] = false;
            }
          }
        });
      },
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/ui/search/provided_service.png"),
                    ),
                  ),
                ),
                Text(
                  "Provided Service",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )
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
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/ui/search/seeked_service.png"),
                  ),
                ),
              ),
              Text(
                "Seeked Service",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ],
          )),
        ),
      ],
      isSelected: isSelected,
    );
  }
}
