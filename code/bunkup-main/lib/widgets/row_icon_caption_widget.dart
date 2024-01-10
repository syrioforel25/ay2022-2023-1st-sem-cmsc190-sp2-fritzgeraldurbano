import 'package:flutter/material.dart';

class RowWithIconAndCaption extends StatelessWidget {
  final IconData icon;
  final String caption;

  const RowWithIconAndCaption({Key? key, required this.icon, required this.caption}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                TableCell(
                  child: Icon(icon, size: 80, color: Color.fromRGBO(39, 66, 147, 1.0)),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      caption,
                      style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
