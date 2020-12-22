import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DropDownMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(left: 50.0, right: 50.0),
          child: Text(
            "gender".tr().toString(),
            style: TextStyle(
                fontSize: 20.0.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black38),
          ),
        ),
        SizedBox(
          width: 20.0.w,
        ),
        new DropdownButton<String>(
          value: "male".tr().toString(),
          items: <String>[
            'male'.tr().toString(),
            'female'.tr().toString(),
          ].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(
                value,
                style: TextStyle(fontSize: 15.0.sp),
              ),
            );
          }).toList(),
          onChanged: (String value1) {
            print(value1);
            return value1;
          },
        )
      ],
    );
  }
}
