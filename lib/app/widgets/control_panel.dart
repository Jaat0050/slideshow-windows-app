import 'package:flutter/material.dart';

class ControlPanel extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onPause;
  final ValueChanged<double> onSpeedChange;
  final double currentSpeed;

  ControlPanel({
    required this.onStart,
    required this.onPause,
    required this.onSpeedChange,
    required this.currentSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onStart,
          child: Text('Start'),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: onPause,
          child: Text('Pause'),
        ),
        SizedBox(width: 10),
        Text('Speed:'),
        Slider(
          min: 0.5,
          max: 4.0,
          divisions: 7,
          label: '${currentSpeed.toStringAsFixed(1)}x',
          value: currentSpeed,
          onChanged: onSpeedChange,
        ),
      ],
    );
  }
}
