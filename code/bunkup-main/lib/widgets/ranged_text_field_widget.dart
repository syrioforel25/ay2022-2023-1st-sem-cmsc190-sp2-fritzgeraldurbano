import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RangedTextFieldWidget extends StatelessWidget {
  final TextEditingController? minEditingController;
  final TextEditingController? maxEditingController;
  final IconData? iconData;
  final String? minLabelText;
  final String? maxLabelText;
  final Function(RangeValues) onRangeChanged;

  const RangedTextFieldWidget({
    Key? key,
    this.minEditingController,
    this.maxEditingController,
    this.iconData,
    this.minLabelText,
    this.maxLabelText,
    required this.onRangeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder whiteBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: Color.fromRGBO(112,116,127, 1.0)),
    );

    return Row(
      children: [
        Icon(iconData, color: const Color.fromRGBO(39, 66, 147, 1.0)), // Add icon
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: minEditingController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: minLabelText,
              labelStyle: TextStyle(color: Color.fromRGBO(112,116,127, 1.0)),
              border: whiteBorder,
              enabledBorder: whiteBorder,
              focusedBorder: whiteBorder,
            ),
            onChanged: (value) {
              _handleRangeChanged();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "-",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        Expanded(
          child: TextField(
            controller: maxEditingController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              labelText: maxLabelText,
              labelStyle: TextStyle(color: Color.fromRGBO(112,116,127, 1.0)),
              border: whiteBorder,
              enabledBorder: whiteBorder,
              focusedBorder: whiteBorder,
            ),
            onChanged: (value) {
              _handleRangeChanged();
            },
          ),
        ),
      ],
    );
  }

  void _handleRangeChanged() {
    double minValue = double.tryParse(minEditingController?.text ?? '') ?? 0.0;
    double maxValue = double.tryParse(maxEditingController?.text ?? '') ?? 0.0;

    RangeValues rangeValues = RangeValues(minValue, maxValue);
    onRangeChanged(rangeValues);
  }
}
