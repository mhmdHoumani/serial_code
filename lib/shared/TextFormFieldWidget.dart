import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senior_project/StyleTXT.dart';

Widget getDefaultTextFormField(
        {required bool obscure,
        IconData? iconData,
        required String lblText,
        required TextInputAction txtInputAction,
        IconButton? iconData2,
        required TextEditingController textEditingController,
        TextInputType? type,
        void Function()? submitted,
        required bool isReadable,
        required TextStyle style}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey[300]!.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextFormField(
          readOnly: isReadable,
          controller: textEditingController,
          obscureText: obscure,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                iconData,
                size: 30,
                color: Colors.white,
              ),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: iconData2,
            ),
            labelText: lblText,
            hintStyle: style,
            labelStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
          style: style,
          onTap: submitted,
          textInputAction: txtInputAction,
          keyboardType: type,
        ),
      ),
    );
