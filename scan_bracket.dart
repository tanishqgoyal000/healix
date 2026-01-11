import 'package:flutter/material.dart';

class ScanBracket extends StatefulWidget {
  final ValueChanged<Rect> onChange;
  const ScanBracket({super.key, required this.onChange});

  @override
  State<ScanBracket> createState() => _ScanBracketState();
}

class _ScanBracketState extends State<ScanBracket> {
  double w = 260, h = 120;

  @override
  Widget build(BuildContext context) {
    final center = MediaQuery.of(context).size.center(Offset.zero);
    widget.onChange(Rect.fromCenter(center: center, width: w, height: h));

    return GestureDetector(
      onPanUpdate: (d) {
        setState(() {
          w = (w + d.delta.dx).clamp(150, 350);
          h = (h + d.delta.dy).clamp(80, 200);
        });
      },
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 3),
        ),
      ),
    );
  }
}
