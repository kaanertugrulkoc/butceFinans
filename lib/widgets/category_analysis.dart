import 'package:flutter/material.dart';

class CategoryAnalysis extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final Color color;

  const CategoryAnalysis({
    super.key,
    required this.categories,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Henüz veri bulunmuyor'),
      );
    }

    // Toplam tutarı hesapla
    final totalAmount = categories.fold<double>(
      0.0,
      (sum, category) => sum + (category['total'] as double? ?? 0.0),
    );

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: categories.map((category) {
            final total = category['total'] as double? ?? 0.0;
            final percentage = totalAmount > 0 ? total / totalAmount : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      category['category'] as String? ?? 'Kategorisiz',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: color.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₺${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '(${(percentage * 100).toStringAsFixed(1)}%)',
                          style: TextStyle(
                            color: color.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
