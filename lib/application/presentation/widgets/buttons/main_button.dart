import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    required this.label,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final Function() onPressed;
  final String label;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        height: 55,
        width: MediaQuery.of(context).size.width,
        child: MaterialButton(
          color: Theme.of(context).colorScheme.primary,
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
