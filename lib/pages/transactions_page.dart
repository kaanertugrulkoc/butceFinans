import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transactions_controller.dart';
import '../widgets/category_analysis.dart';
import '../widgets/transaction_list.dart';
import '../widgets/transaction_form.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionsController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('İşlemler'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Gelirler'),
              Tab(text: 'Giderler'),
            ],
            onTap: (index) {
              controller.loadTransactions();
              controller.loadCategoryAnalyses();
            },
          ),
        ),
        body: TabBarView(
          children: [
            // Gelirler Tab
            RefreshIndicator(
              onRefresh: () async {
                await controller.loadTransactions();
                await controller.loadCategoryAnalyses();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Obx(() => CategoryAnalysis(
                          title: 'Gelir Kategorileri',
                          categories: controller.incomeCategories,
                          total: controller.totalIncome.value,
                        )),
                    const SizedBox(height: 16),
                    Obx(() => TransactionList(
                          transactions: controller.incomes,
                          isIncome: true,
                          onDelete: controller.deleteIncome,
                        )),
                  ],
                ),
              ),
            ),
            // Giderler Tab
            RefreshIndicator(
              onRefresh: () async {
                await controller.loadTransactions();
                await controller.loadCategoryAnalyses();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Obx(() => CategoryAnalysis(
                          title: 'Gider Kategorileri',
                          categories: controller.expenseCategories,
                          total: controller.totalExpense.value,
                        )),
                    const SizedBox(height: 16),
                    Obx(() => TransactionList(
                          transactions: controller.expenses,
                          isIncome: false,
                          onDelete: controller.deleteExpense,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => const TransactionForm(),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
