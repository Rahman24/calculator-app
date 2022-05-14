import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final color;
  // ignore: prefer_typing_uninitialized_variables
  final textColor;
  // ignore: prefer_typing_uninitialized_variables
  final String buttonText;
  // ignore: prefer_typing_uninitialized_variables
  final buttontapped;

  // ignore: prefer_typing_uninitialized_variables
  final iconbutton;

  // ignore: use_key_in_widget_constructors
  const Button(
      {this.color,
      this.textColor,
      required this.buttonText,
      this.iconbutton = Null,
      this.buttontapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttontapped,
      child: Padding(
          padding: const EdgeInsets.all(4),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                color: color,
                child: Center(
                  child: iconbutton == Null
                      ? Text(
                          buttonText,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Icon(iconbutton, color: Colors.white),
                ),
              ),
            ),
          )),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('textColor', textColor));
  }
}
