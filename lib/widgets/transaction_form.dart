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
  bool _isIncome = true;

  // Ay ve yıl seçimi için değişkenler
  late int _selectedMonth;
  late int _selectedYear;

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
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<TransactionsController>();
      final transaction = {
        'amount': double.parse(_amountController.text),
        'description': _descriptionController.text,
        'category': _categoryController.text,
        'date': DateTime(_selectedYear, _selectedMonth).toIso8601String(),
        'month': _selectedMonth,
        'year': _selectedYear,
      };

      if (_isIncome) {
        controller.addIncome(transaction);
      } else {
        controller.addExpense(transaction);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('İşlem Türü:'),
                  const SizedBox(width: 16),
                  ChoiceChip(
                    label: const Text('Gelir'),
                    selected: _isIncome,
                    onSelected: (selected) {
                      setState(() {
                        _isIncome = selected;
                        _categoryController.text = '';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Gider'),
                    selected: !_isIncome,
                    onSelected: (selected) {
                      setState(() {
                        _isIncome = !selected;
                        _categoryController.text = '';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Ay seçimi
              DropdownButtonFormField<int>(
                value: _selectedMonth,
                decoration: const InputDecoration(
                  labelText: 'Ay',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(12, (index) => index + 1)
                    .map((month) => DropdownMenuItem(
                          value: month,
                          child: Text(_monthNames[month - 1]),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedMonth = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Lütfen bir ay seçin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Yıl seçimi
              DropdownButtonFormField<int>(
                value: _selectedYear,
                decoration: const InputDecoration(
                  labelText: 'Yıl',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(5, (index) => DateTime.now().year - index)
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
                validator: (value) {
                  if (value == null) {
                    return 'Lütfen bir yıl seçin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Miktar',
                  prefixText: '₺',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir miktar girin';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Lütfen geçerli bir sayı girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Açıklama (Opsiyonel)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _categoryController.text.isEmpty
                    ? null
                    : _categoryController.text,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: (_isIncome ? _incomeCategories : _expenseCategories)
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _categoryController.text = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir kategori seçin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
