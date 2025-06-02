import 'package:flutter/material.dart';

class WidgetBoton extends StatelessWidget {
  final Color color;
  final String texto;
  final VoidCallback onPressed;

  const WidgetBoton({
    Key? key,
    required this.color,
    required this.texto,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      ),
      onPressed: onPressed,
      child: Text(
        texto,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}