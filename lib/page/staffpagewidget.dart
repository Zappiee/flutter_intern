import 'package:flutter/material.dart';

class StaffPageWidget extends StatelessWidget {
  final String? staffname;
  final String? number;
  final ValueChanged<String> onChangedName;
  final ValueChanged<String> onChangedNumber;

  const StaffPageWidget({
    Key? key,
    this.staffname = '',
    this.number = '',
    required this.onChangedNumber,
    required this.onChangedName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              const SizedBox(height: 8),
              buildDescription(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: staffname,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The Name cannot be empty' : null,
        onChanged: onChangedName,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 5,
        initialValue: number,
        style: const TextStyle(color: Colors.white60, fontSize: 18),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Colors.white60),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The phone number cannot be empty'
            : null,
        onChanged: onChangedNumber,
      );
}
