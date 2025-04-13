import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitirme_projesi_app/modules/transactions/transactions_controller.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({Key? key}) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  String _selectedType = 'income';
  DateTime _selectedDate = DateTime.now();
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedMonth = picked.month;
        _selectedYear = picked.year;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<TransactionsController>();
      final transaction = {
        'amount': double.parse(_amountController.text),
        'description': _descriptionController.text,
        'category': _categoryController.text,
        'date': _selectedDate.toIso8601String(),
        'type': _selectedType,
      };

      if (_selectedType == 'income') {
        controller.addIncome(transaction);
      } else {
        controller.addExpense(transaction);
      }

      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Yeni İşlem Ekle',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: const [
                DropdownMenuItem(value: 'income', child: Text('Gelir')),
                DropdownMenuItem(value: 'expense', child: Text('Gider')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'İşlem Türü',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tutar',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen bir tutar girin';
                }
                if (double.tryParse(value) == null) {
                  return 'Lütfen geçerli bir tutar girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen bir açıklama girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
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
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Tarih'),
              subtitle: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
