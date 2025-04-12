import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final Function(int) onDelete;
  final bool isIncome;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.onDelete,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Henüz işlem bulunmuyor'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final amount = transaction['amount'] as double? ?? 0.0;
        final description = transaction['description'] as String? ?? '';
        final category = transaction['category'] as String? ?? 'Kategorisiz';
        final date = DateTime.parse(
            transaction['date'] as String? ?? DateTime.now().toIso8601String());

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isIncome ? Colors.green : Colors.red,
              child: Icon(
                isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.white,
              ),
            ),
            title: Text(
              '₺${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (description.isNotEmpty) Text(description),
                Text('Kategori: $category'),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDelete(transaction['id'] as int),
            ),
          ),
        );
      },
    );
  }
}
