import 'package:flutter/material.dart';

class MainButtonWithIcon extends StatelessWidget {
  const MainButtonWithIcon({
    required this.icon,
    required this.onPressed,
    required this.labelText,
    required this.backgroundColor,
    required this.height,
    Key? key,
  }) : super(key: key);

  final Color backgroundColor;
  final String labelText;
  final IconData icon;
  final Function() onPressed;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: height,
          child: ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(backgroundColor)),
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(labelText)),
        ),
      ),
    );
  }
}
