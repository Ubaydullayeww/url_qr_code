import 'package:flutter/cupertino.dart';
import 'package:url_qr_code/service/provider/provider.dart';

class QRProvider extends InheritedNotifier<QRDataProvider> {
  const QRProvider({
     super.key,
    required QRDataProvider notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static QRDataProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<QRProvider>()!.notifier!;
  }



}
