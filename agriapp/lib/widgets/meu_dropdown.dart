import 'package:flutter/material.dart';

class MeuDropdown extends StatelessWidget {
  final int? initialValue;
  final String label;
  final List<dynamic> items;
  final Function(int?) onChanged;

  const MeuDropdown({
    super.key,
    required this.initialValue,
    required this.label,
    required this.items,
    required this.onChanged,
  });

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
            initialValue: initialValue,
            items: items
                .map((item) => DropdownMenuItem<int>(
                      value: item.id is int ? item.id : int.tryParse(item.id.toString()),
                      child: Text(item.nome ?? item.toString()),
                    ))
                .toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            ),
          ),
        ],
      ),
    );
  }
}