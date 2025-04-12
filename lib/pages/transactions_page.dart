import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transactions_controller.dart';
import '../widgets/category_analysis.dart';
import '../widgets/transaction_list.dart';
import '../widgets/transaction_form.dart';

class TransactionsPage extends StatelessWidget {
  final TransactionsController _controller = Get.put(TransactionsController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: 'Gelirler'),
                  Tab(text: 'Giderler'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(() => DropdownButton<int>(
                          value: _controller.selectedMonth.value,
                          items: List.generate(12, (index) => index + 1)
                              .map((month) => DropdownMenuItem(
                                    value: month,
                                    child: Text('$month. Ay'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              _controller.setSelectedMonth(value);
                            }
                          },
                        )),
                    Obx(() => DropdownButton<int>(
                          value: _controller.selectedYear.value,
                          items: List.generate(
                                  5, (index) => DateTime.now().year - index)
                              .map((year) => DropdownMenuItem(
                                    value: year,
                                    child: Text('$year'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              _controller.setSelectedYear(value);
                            }
                          },
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildIncomeTab(),
            _buildExpenseTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.bottomSheet(
              TransactionForm(),
              isScrollControlled: true,
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildIncomeTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(() => CategoryAnalysis(
                categories: _controller.incomeCategories,
                isIncome: true,
              )),
          Obx(() => TransactionList(
                transactions: _controller.incomes,
                isIncome: true,
                onDelete: _controller.deleteIncome,
              )),
        ],
      ),
    );
  }

  Widget _buildExpenseTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(() => CategoryAnalysis(
                categories: _controller.expenseCategories,
                isIncome: false,
              )),
          Obx(() => TransactionList(
                transactions: _controller.expenses,
                isIncome: false,
                onDelete: _controller.deleteExpense,
              )),
        ],
      ),
    );
  }
}
