import 'package:flutter/material.dart';

class QRDataProvider extends ChangeNotifier {
  String _qrData = '';

  // Initialize with values that exist in your dropdown lists
  int selectedPattern = 0;
  String selectedColor = 'Blue';
  String selectedLogo = 'BMW'; // Changed from 'None' to 'BMW'
  String selectedFormat = 'PNG';

  String get qrData => _qrData;

  void updateQrData(String newData) {
    _qrData = newData;
    notifyListeners();
  }

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

  Color getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.black;
    }
  }
}