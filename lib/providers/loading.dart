import 'package:flutter/material.dart';
import 'dart:developer';

class Loading with ChangeNotifier {
  double? persen;
  updatepersen(int a, int b) {
    log(a.toString());
    log(b.toString());
    persen = a.toDouble() / b.toDouble();
    log(persen.toString() + ' ini dia');
    notifyListeners();
  }
}
