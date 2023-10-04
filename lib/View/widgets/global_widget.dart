import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class GlobalWidget {
  static InputDecoration customInputDecoration(String label) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      border: OutlineInputBorder(
        borderSide: const BorderSide(style: BorderStyle.none, width: 0),
        borderRadius: BorderRadius.circular(20),
      ),
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
      label: Text(
        label,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  static Widget buttonPrimary({
    required String title,
    required VoidCallback onTapButton,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: onTapButton,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 32,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: const Color.fromARGB(255, 147, 218, 251),
          ),
          borderRadius: BorderRadius.circular(15),
          color: isActive
              ? const Color.fromARGB(255, 179, 220, 254)
              : Colors.transparent,
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.blue),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static void customAwesomeDialog({
    required BuildContext context,
    required String title,
    required String desc,
    required bool dialogSuccess,
    bool isPop = true,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: dialogSuccess ? DialogType.success : DialogType.error,
      title: title,
      desc: desc,
      btnOkOnPress: isPop ? () => Navigator.of(context).pop() : () => {},
      btnOkColor: Colors.grey,
      btnOkText: "Oke",
    ).show();
  }
}
