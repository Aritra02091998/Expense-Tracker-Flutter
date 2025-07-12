import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/model/expense_blueprint.dart';

final dateFormatter = DateFormat.yMd();

class AddNewExpense extends StatefulWidget {
  // Class Variable which takes in Function.
  final void Function(Expense expense) addNewExpenseItem;

  const AddNewExpense({super.key, required this.addNewExpenseItem});

  @override
  State<AddNewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<AddNewExpense> {
  // For saving User Input
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // Initially selected date
  DateTime? _userSelectedDate;

  // Initial Default Category
  Category _selectedCategory = Category.leisure;

  // For showing date picker
  void _showDatePicker() async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(context: context, initialDate: now, firstDate: firstDate, lastDate: now);

    setState(() {
      _userSelectedDate = pickedDate;
    });
  }

  // Submit expense Data.
  void submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final bool isAmountInvalid = enteredAmount == null || enteredAmount < 1;

    if (_titleController.text.trim().isEmpty || isAmountInvalid || _userSelectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text('Please make sure you enter correct values in each of the fields'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      // The return is written inside the if block bcz, if we made into
      // the if block, that means wrong values are present. We wont proceed
      // with wrong input values. Hence returning to the caller.
      return;
    }

    // Else case: if all of the enetered input is fine.
    // Using AddNewExpense Class method using (widget.)
    widget.addNewExpenseItem(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _userSelectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  // Delete the controller after the modal is closed.
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: [

          // Expense Title Input
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text('Title')),
          ),

          // Expense Amount and (Label, Date) Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(prefixText: '\$ ', label: Text('Amount')),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_userSelectedDate == null ? 'No Date Selected' : dateFormatter.format(_userSelectedDate!)),
                    IconButton(onPressed: _showDatePicker, icon: Icon(Icons.calendar_month_outlined)),
                  ],
                ),
              ),
            ],
          ),

          // Vertical Spacing
          const SizedBox(height: 20),

          // Button Group
          Row(
            children: [
              // Category Dropdown
              DropdownButton(
                value: _selectedCategory,
                items: Category.values.map((eachCategory) {
                  return DropdownMenuItem(value: eachCategory, child: Text(eachCategory.name.toUpperCase()));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),

              // Space between Dropdown and Button Group.
              const Spacer(),

              // Cancel Button
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),

              // Save Expense Button
              ElevatedButton(onPressed: submitExpenseData, child: const Text('Save Expense')),
            ],
          ),
        ],
      ),
    );
  }
}
