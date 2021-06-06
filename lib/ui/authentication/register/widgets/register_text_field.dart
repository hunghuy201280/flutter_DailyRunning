import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';

class RegisterTextField extends StatelessWidget {
  final TextEditingController textController;
  final String title;
  final String Function(String text) validator;
  final void Function(String text) onFieldSubmitted;
  final bool isPassword;
  final FocusNode focusNode;
  final TextInputType inputType;
  const RegisterTextField({
    @required this.textController,
    @required this.title,
    @required this.validator,
    this.onFieldSubmitted,
    this.focusNode,
    this.isPassword = false,
    @required this.inputType,
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
        TextFormField(
          keyboardType: inputType,
          obscureText: isPassword,
          focusNode: focusNode,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
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
