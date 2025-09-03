import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {

  void toastmessage(BuildContext context, String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: const Color.fromARGB(255, 172, 8, 8),
      messageColor: Colors.white,
    ).show(context);
  }

  /// Try direct call without dialog
  Future<void> makePhoneCall(String phoneNumber) async {
    try {
      final Uri phoneUri = Uri.parse('tel:$phoneNumber');
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      //Utils.toastMessage("Unable to make call", AppColors.redColor);
    }
  }


}
