import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final String label;
  final IconData preIcon;
  final bool isPassword;
  final TextEditingController textController;
  final Function validator;
  final Function onFieldSubmitted;
  final FocusNode focusNode;
  final TextInputType inputType;
  const LoginTextField({
    @required this.label,
    @required this.preIcon,
    @required this.textController,
    this.isPassword = false,
    @required this.validator,
    this.onFieldSubmitted,
    this.focusNode,
    this.inputType = TextInputType.visiblePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: TextFormField(
        focusNode: focusNode ?? FocusNode(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        textAlign: TextAlign.center,
        onFieldSubmitted: onFieldSubmitted ?? (text) {},
        controller: textController,
        obscureText: isPassword,
        keyboardType: inputType,
        decoration: InputDecoration(
            labelText: '$label*',
            prefixIcon: Icon(
              preIcon,
            ),
            suffixIcon: IconButton(
              onPressed: () => textController.clear(),
              icon: Icon(Icons.clear),
            )),
      ),
    );
  }
}
