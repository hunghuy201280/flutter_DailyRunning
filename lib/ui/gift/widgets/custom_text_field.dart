import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_daily_running_admin/utils/constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTextField extends StatelessWidget {
  final bool readonly;
  final String label;
  final String Function(String) validator;
  final FocusNode focusNode;
  final TextEditingController controller;
  final void Function(String) onFieldSubmitted;
  const CustomTextField(
      {this.readonly = false,
      @required this.label,
      this.validator,
      @required this.focusNode,
      @required this.controller,
      this.onFieldSubmitted});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        onFieldSubmitted: onFieldSubmitted,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        readOnly: readonly,
        validator: validator,
        textAlign: TextAlign.center,
        focusNode: focusNode,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          filled: true,
          labelText: label,
          labelStyle: TextStyle(
            color: focusNode.hasFocus ? kPrimaryColor : Colors.black54,
          ),
          suffixIcon: !readonly
              ? IconButton(
                  onPressed: () => controller.clear(),
                  iconSize: 20,
                  icon: Icon(
                    FontAwesomeIcons.timesCircle,
                    color: focusNode.hasFocus ? kPrimaryColor : Colors.black54,
                  ),
                )
              : null,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
