import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transactions_controller.dart';
import '../widgets/transaction_form.dart';
import '../widgets/transaction_list.dart';
import '../widgets/category_analysis.dart';

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
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Gelirler'),
              Tab(text: 'Giderler'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Gelirler Tab
            SingleChildScrollView(
              child: Column(
                children: [
                  // Toplam Gelir Kartı
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Toplam Gelir',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(() => Text(
                                '₺${controller.totalIncome.value.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),

                  // Kategori Analizi
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Kategori Analizi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Obx(() => CategoryAnalysis(
                        categories: controller.incomeCategories,
                        color: Colors.green,
                      )),

                  // Gelir Listesi
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Son İşlemler',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Obx(() => TransactionList(
                        transactions: controller.incomes,
                        onDelete: controller.deleteIncome,
                        isIncome: true,
                      )),
                ],
              ),
            ),

            // Giderler Tab
            SingleChildScrollView(
              child: Column(
                children: [
                  // Toplam Gider Kartı
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Toplam Gider',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(() => Text(
                                '₺${controller.totalExpense.value.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),

                  // Kategori Analizi
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Kategori Analizi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Obx(() => CategoryAnalysis(
                        categories: controller.expenseCategories,
                        color: Colors.red,
                      )),

                  // Gider Listesi
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Son İşlemler',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Obx(() => TransactionList(
                        transactions: controller.expenses,
                        onDelete: controller.deleteExpense,
                        isIncome: false,
                      )),
                ],
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
