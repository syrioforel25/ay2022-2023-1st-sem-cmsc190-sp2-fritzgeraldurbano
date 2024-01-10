import 'package:flutter/material.dart';

class CustomDropdownWidget extends StatelessWidget {
  final String? selectedValue;
  final List<String>? items;
  final void Function(String?)? onChanged; // Fix the type of onChanged
  final IconData? iconData;
  final String? assetRef;
  final String? labelText;

  const CustomDropdownWidget({
    Key? key,
    this.selectedValue,
    this.items,
    this.onChanged,
    this.iconData,
    this.assetRef,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: iconData != null
            ? Icon(iconData, color: const Color.fromRGBO(39, 66, 147, 1.0))
            : Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset(assetRef.toString()),
        ),
        labelStyle: const TextStyle(
          fontSize: 18,
          color: Color.fromRGBO(112, 116, 127, 1.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Color.fromRGBO(112, 116, 127, 1.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Color.fromRGBO(112, 116, 127, 1.0),
          ),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Colors.white, // Set dropdown menu background color to black
          value: selectedValue,
          items: items?.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                  value,
                  style: TextStyle(color: Colors.black), // Set menu text color to black
                ),
            );
          }).toList() ??
              [],
          onChanged: onChanged, // Pass the onChanged callback here
        ),
      ),
    );
  }
}
