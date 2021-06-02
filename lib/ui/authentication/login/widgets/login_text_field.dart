import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final String hint;
  final IconData preIcon;

  final TextEditingController textController;

  const LoginTextField({
    @required this.hint,
    @required this.preIcon,
    @required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: TextField(
        textAlign: TextAlign.center,
        controller: textController,
        decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(preIcon),
            suffixIcon: IconButton(
              onPressed: () => textController.clear(),
              icon: Icon(Icons.clear),
            )),
      ),
    );
  }
}
