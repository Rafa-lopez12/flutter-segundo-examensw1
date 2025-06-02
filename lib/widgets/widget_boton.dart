import 'package:flutter/material.dart';

class WidgetBoton extends StatelessWidget {
  final Color color;
  final String texto;

  const WidgetBoton({Key? key, required this.color, required this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        ),
        onPressed: () {
          // Acción al presionar el botón
        },
        child: Text(
          texto,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}