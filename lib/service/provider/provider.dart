import 'package:flutter/material.dart';

class QRDataProvider extends ChangeNotifier {
   String _qrData = '';

  String get qrData => _qrData;

  void updateQrData(String newData) {
    _qrData = newData;
    notifyListeners();
  }
   int selectedPattern = 0;
   String selectedColor = 'Blue';
   String selectedLogo = 'None';
   String selectedFormat = 'PNG';


   void selectPattern(int index) {
     selectedPattern = index;
     notifyListeners();
   }

   void selectColor(String color) {
     selectedColor = color;
     notifyListeners();
   }

   void selectLogo(String logo) {
     selectedLogo = logo;
     notifyListeners();
   }

   void selectFormat(String format) {
     selectedFormat = format;
     notifyListeners();
   }

}