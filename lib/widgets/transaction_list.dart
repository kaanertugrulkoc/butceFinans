import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final bool isIncome;
  final Function(int) onDelete;

  const TransactionList({
    Key? key,
    required this.transactions,
    required this.isIncome,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          '${isIncome ? 'Gelir' : 'Gider'} bulunamadı',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final amount = transaction['amount'] as num? ?? 0.0;
        final description = transaction['description'] as String? ?? '';
        final category = transaction['category'] as String? ?? 'Kategorisiz';
        final date =
            transaction['date'] as String? ?? DateTime.now().toIso8601String();
        final id = transaction['id'] as int? ?? 0;

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isIncome ? Colors.green : Colors.red,
              child: Icon(
                isIncome ? Icons.attach_money : Icons.money_off,
                color: Colors.white,
              ),
            ),
            title: Text(
              category,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (description.isNotEmpty) Text(description),
                Text(
                  '${DateTime.parse(date).day}/${DateTime.parse(date).month}/${DateTime.parse(date).year}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${amount.toStringAsFixed(2)}₺',
                  style: TextStyle(
                    color: isIncome ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final result = await Get.dialog<bool>(
                          AlertDialog(
                            title: Text('Silme Onayı'),
                            content: Text(
                                'Bu ${isIncome ? 'gelir' : 'gider'} kaydını silmek istediğinizden emin misiniz?'),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(result: false),
                                child: Text('İptal'),
                              ),
                              TextButton(
                                onPressed: () => Get.back(result: true),
                                child: Text('Sil'),
                              ),
                            ],
                          ),
                        ) ??
                        false;

                    if (result) {
                      onDelete(id);
                      Get.snackbar(
                        'Başarılı',
                        '${isIncome ? 'Gelir' : 'Gider'} başarıyla silindi',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
