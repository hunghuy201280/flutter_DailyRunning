import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';

class RegisterTextField extends StatelessWidget {
  final TextEditingController textController;
  final String title;

  const RegisterTextField({
    @required this.textController,
    @required this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            title,
            style: kTitleTextStyle,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          textAlign: TextAlign.center,
          controller: textController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () => textController.clear(),
              icon: Icon(Icons.clear),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
