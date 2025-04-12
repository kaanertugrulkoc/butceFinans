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

  final List<String> _incomeCategories = [
    'Maaş',
    'Mesai',
    'Yatırım',
    'Kira',
    'İkramiye',
    'Ek Gelir',
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
        'date': DateTime.now().toIso8601String(),
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
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Miktar',
                  prefixText: '₺',
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
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _categoryController.text.isEmpty
                    ? null
                    : _categoryController.text,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
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
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
