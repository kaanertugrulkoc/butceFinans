import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transactions_controller.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _transactionsController = Get.find<TransactionsController>();

  bool _isIncome = true;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  // Türkçe ay isimleri
  final List<String> _monthNames = [
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

  final List<String> _incomeCategories = [
    'Maaş',
    'Yatırım',
    'Freelance',
    'Diğer',
  ];

  final List<String> _expenseCategories = [
    'Kira',
    'Faturalar',
    'Market',
    'Ulaşım',
    'Sağlık',
    'Eğlence',
    'Diğer',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Yeni ${_isIncome ? 'Gelir' : 'Gider'} Ekle',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isIncome = true;
                      });
                    },
                    icon: Icon(Icons.add_circle_outline),
                    label: Text('Gelir'),
                    style: TextButton.styleFrom(
                      backgroundColor: _isIncome ? Colors.green[100] : null,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isIncome = false;
                      });
                    },
                    icon: Icon(Icons.remove_circle_outline),
                    label: Text('Gider'),
                    style: TextButton.styleFrom(
                      backgroundColor: !_isIncome ? Colors.red[100] : null,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Tutar',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen bir tutar girin';
                }
                if (double.tryParse(value) == null) {
                  return 'Lütfen geçerli bir sayı girin';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen bir kategori girin';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedMonth,
                    decoration: InputDecoration(
                      labelText: 'Ay',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(12, (index) => index + 1)
                        .map((month) => DropdownMenuItem(
                              value: month,
                              child: Text('$month. Ay'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedMonth = value;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedYear,
                    decoration: InputDecoration(
                      labelText: 'Yıl',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        List.generate(5, (index) => DateTime.now().year - index)
                            .map((year) => DropdownMenuItem(
                                  value: year,
                                  child: Text('$year'),
                                ))
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedYear = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final transaction = {
                    'amount': double.parse(_amountController.text),
                    'description': _descriptionController.text,
                    'category': _categoryController.text,
                    'month': _selectedMonth,
                    'year': _selectedYear,
                  };

                  if (_isIncome) {
                    await _transactionsController.addIncome(transaction);
                  } else {
                    await _transactionsController.addExpense(transaction);
                  }

                  Get.back();
                }
              },
              child: Text('Ekle'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
