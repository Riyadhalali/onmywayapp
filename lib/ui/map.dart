import 'package:flutter/material.dart';

class MapClass extends StatefulWidget {
  static const id = 'map';
  @override
  _MapClassState createState() => _MapClassState();
}

class _MapClassState extends State<MapClass> {
  static const Map<String, int> frequencyOptions = {
    "30 seconds": 30,
    "1 minute": 1,
    "2 minutes": 2,
  };

  int frequencyValue = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<int>(
        items: frequencyOptions
            .map(
              (description, value) {
                return MapEntry(
                  description,
                  DropdownMenuItem<int>(
                    value: value,
                    child: Text(description),
                  ),
                );
              },
            )
            .values
            .toList(),
        value: frequencyValue,
        onChanged: (newValue) {
          setState(() {
            frequencyValue = newValue;
            //   print(frequencyValue);
          });
        },
      ),
    );
  }
}
