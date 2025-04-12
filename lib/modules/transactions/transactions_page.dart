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

        // Null kontrolü ve tip dönüşümü
        final amount = (transaction['amount'] ?? 0.0) as double;
        final description = transaction['description']?.toString();
        final date = transaction['date']?.toString() ?? '';
        final category = transaction['category']?.toString();

        return Card(
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
                if (date.isNotEmpty)
                  Text(
                    controller.formatDate(date),
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
