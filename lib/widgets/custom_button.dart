import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
final String label;
final VoidCallback onPressed;
final bool outline;
const CustomButton({super.key, required this.label, required this.onPressed, this.outline = false});


@override
Widget build(BuildContext context) {
if (outline) {
return OutlinedButton(onPressed: onPressed, child: Text(label));
}
return ElevatedButton(
style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
onPressed: onPressed,
child: Text(label),
);
}
}