import 'package:url_launcher/url_launcher.dart';

import '../ui/global_widgets/custom_dialog.dart';

void launchMap(String latitude, String longitude) {
  try {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    launch(url);
  } catch (e) {
    CustomDialog.showSnackBar(message: 'Error launching map: $e');
  }
}

String labelize(String s) {
  if (s.isEmpty) return s;
  return s
      .replaceAll('_', ' ')
      .split(' ')
      .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
      .join(' ');
}

Future<void> launchTel(String phone) async {
  try {
    final uri = Uri(scheme: 'tel', path: phone);
    await launchUrl(uri);
  } catch (e) {
    CustomDialog.showSnackBar(message: 'Error launching phone dialer: $e');
  }
}
