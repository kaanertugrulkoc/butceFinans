import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'transactions_controller.dart';

class TransactionsPage extends GetView<TransactionsController> {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('İşlem Geçmişi'),
          bottom: TabBar(
            onTap: controller.changeTab,
            tabs: const [
              Tab(text: 'Gelirler'),
              Tab(text: 'Giderler'),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return TabBarView(
            children: [
              _buildTransactionList(controller.incomes, true),
              _buildTransactionList(controller.expenses, false),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTransactionList(
      List<Map<String, dynamic>> transactions, bool isIncome) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          isIncome ? 'Henüz gelir eklenmemiş' : 'Henüz gider eklenmemiş',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final amount = transaction['amount'] as num;
        final description = transaction['description'] as String?;
        final date = transaction['date'] as String;
        final category = transaction['category'] as String?;
        final id = transaction['id'] as int;

        return Dismissible(
          key: Key('$id-${isIncome ? 'income' : 'expense'}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          confirmDismiss: (direction) async {
            return await Get.dialog(
              AlertDialog(
                title: const Text('Silme Onayı'),
                content: Text(
                    'Bu ${isIncome ? 'gelir' : 'gider'} kaydını silmek istediğinizden emin misiniz?'),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: const Text('İptal'),
                  ),
                  TextButton(
                    onPressed: () => Get.back(result: true),
                    child: const Text('Sil'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            if (isIncome) {
              controller.deleteIncome(id);
            } else {
              controller.deleteExpense(id);
            }
            Get.snackbar(
              'Başarılı',
              '${isIncome ? 'Gelir' : 'Gider'} kaydı silindi',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isIncome ? Colors.green : Colors.red,
                child: Icon(
                  isIncome ? Icons.attach_money : Icons.money_off,
                  color: Colors.white,
                ),
              ),
              title: Text(
                '${amount.toStringAsFixed(2)}₺',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isIncome ? Colors.green : Colors.red,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (description != null && description.isNotEmpty)
                    Text(description),
                  if (!isIncome && category != null)
                    Text(
                      'Kategori: $category',
                      style: const TextStyle(fontSize: 12),
                    ),
                  Text(
                    controller.formatDate(date),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
