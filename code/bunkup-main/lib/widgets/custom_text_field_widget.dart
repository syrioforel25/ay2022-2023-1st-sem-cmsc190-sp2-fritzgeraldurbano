import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController? editingController;
  final IconData? iconData;
  final String? assetRef;
  final String? labelText;
  final bool? isObscure;
  final bool? isNumberInput;
  final int? maxLength;
  const CustomTextFieldWidget({Key? key,
    this.editingController,
    this.iconData,
    this.assetRef,
    this.labelText,
    this.isObscure,
    this.isNumberInput = false,
    this.maxLength,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.black),
      controller: editingController,
      keyboardType: isNumberInput! ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumberInput!
          ? [FilteringTextInputFormatter.digitsOnly] // Only allow digits
          : [],
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: iconData != null
            ? Icon(iconData, color: const Color.fromRGBO(39, 66, 147, 1.0),)
            : Padding(
                padding: EdgeInsets.all(8),
                child: Image.asset(assetRef.toString()),
              ),
        labelStyle: const TextStyle(
          fontSize: 18,
          color: Color.fromRGBO(112,116,127, 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Color.fromRGBO(112,116,127, 1.0),
          )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
                color: Color.fromRGBO(112,116,127, 1.0),
            )
        ),
        counterText: "", // To hide the default character count display
        counterStyle: TextStyle(fontSize: 0),
        counter: Offstage(),
        // Set the maximum length dynamically
        //counterText: maxLength != null ? 'Maximum length: $maxLength' : '',
      ),
      obscureText: isObscure!,
      maxLength: maxLength,
    );
  }
}
