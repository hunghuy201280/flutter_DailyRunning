import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final String hint;
  final IconData preIcon;

  final TextEditingController usernameController;

  const LoginTextField({
    @required this.hint,
    @required this.preIcon,
    @required this.usernameController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: TextField(
        controller: usernameController,
        decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(preIcon),
            suffixIcon: IconButton(
              onPressed: () => usernameController.clear(),
              icon: Icon(Icons.clear),
            )),
      ),
    );
  }
}
