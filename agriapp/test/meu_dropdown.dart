import 'package:flutter/material.dart';

class MeuDropdown extends StatelessWidget {
  final int? value;
  final String label;
  final List<dynamic> items;
  final Function(int?) onChanged;

  const MeuDropdown({
    Key? key,
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16.0)),
          const SizedBox(height: 8.0),
          DropdownButtonFormField<int>(
            value: value,
            items: items
                .map((item) => DropdownMenuItem<int>(
                      value: item['id'],
                      child: Text(item['nome']),
                    ))
                .toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            ),
          ),
        ],
      ),
    );
  }
}