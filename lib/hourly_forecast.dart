import "package:flutter/material.dart";

class HourlyForeCast extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;
  const HourlyForeCast({
    super.key,
    required this.time,
    required this.temperature,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Icon(
                icon,
                size: 32,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                temperature,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
