import 'package:flutter/material.dart';

//-> this button is for social buttons
class SocialButton extends StatelessWidget {
  final Function functionToDo;
  final String buttonText;
  final String image;
  SocialButton({this.functionToDo, this.buttonText, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      color: Colors.white,
      child: TextButton(
        onPressed: functionToDo,
        child: Row(
          children: [
            Image.asset(image),
            SizedBox(
              width: 10.0,
            ),
            Text(
              buttonText,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        // style: ElevatedButton.styleFrom(primary: Colors.white),
      ),
    );
  }
}
