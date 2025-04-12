import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transactions_controller.dart';

class CategoryAnalysis extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> categories;
  final double total;

  const CategoryAnalysis({
    super.key,
    required this.title,
    required this.categories,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionsController>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  children: [
                    // Ay seçimi
                    Obx(() => DropdownButton<int>(
                          value: controller.selectedMonth.value,
                          items: List.generate(12, (index) => index + 1)
                              .map((month) => DropdownMenuItem(
                                    value: month,
                                    child: Text(_getMonthName(month)),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.setSelectedMonth(value);
                            }
                          },
                        )),
                    const SizedBox(width: 8),
                    // Yıl seçimi
                    Obx(() => DropdownButton<int>(
                          value: controller.selectedYear.value,
                          items: List.generate(
                                  5, (index) => DateTime.now().year - index)
                              .map((year) => DropdownMenuItem(
                                    value: year,
                                    child: Text('$year'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.setSelectedYear(value);
                            }
                          },
                        )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (categories.isEmpty)
              const Center(
                child: Text('Henüz veri bulunmuyor'),
              )
            else
              Column(
                children: categories.map((category) {
                  final percentage =
                      (category['total'] as double) / total * 100;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category['category'] as String,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              '₺${category['total'].toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            title == 'Gelir Kategorileri'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '%${percentage.toStringAsFixed(1)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    final monthNames = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];
    return monthNames[month - 1];
  }
}
