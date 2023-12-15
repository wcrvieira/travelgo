import 'package:flutter/material.dart';
import 'package:travelgo/models/travel.dart';

class TravelForm extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Travel travel;

  TravelForm(this.travel);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}