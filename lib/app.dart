import 'package:flutter/material.dart';
import 'package:url_qr_code/screen/qr_code_generator_page.dart';
import 'package:url_qr_code/service/global_provider/inherted.dart';
import 'package:url_qr_code/service/provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
final qrProvider = QRDataProvider();

    return QRProvider(
        notifier: qrProvider,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'QR Generator',
          home:  QrCodeGeneratorPage(),
        )
    );
  }
}
