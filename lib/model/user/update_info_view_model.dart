import 'package:flutter/cupertino.dart';

class UpdateInfoViewModel extends ChangeNotifier {
  FocusNode displayNameFocusNode = FocusNode();
  TextEditingController nameController = TextEditingController();
  UpdateInfoViewModel() {
    displayNameFocusNode.addListener(() => notifyListeners());
  }
}
