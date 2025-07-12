import 'package:expense_tracker/chart/chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/model/expense_blueprint.dart';
import 'package:expense_tracker/widgets/expenses_list.dart';
import 'package:expense_tracker/widgets/add_new_expense_modal.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  // Dummy data for demonstration
  final List<Expense> _registeredExpenses = [
    Expense(title: 'lunch', amount: 15.99, date: DateTime.now(), category: Category.food),
    Expense(title: 'Cinema', amount: 50.99, date: DateTime.now(), category: Category.leisure),
    Expense(title: 'Course', amount: 100.99, date: DateTime.now(), category: Category.work),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return AddNewExpense(addNewExpenseItem: addNewExpenseItem);
      },
    );
  }

  void addNewExpenseItem(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void removeExistingExpense(Expense expense) {
    // In case user presses Undo, we need to keep the deleted expense at the same location
    final int targetExpenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });

    // Clear previous Snack Messages.
    ScaffoldMessenger.of(context).clearSnackBars();

    // Delete and Generate Snack Message for the current expense Item.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text('Expense Removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(targetExpenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);

    // When no expense is present on the app.
    Widget mainPageContent = Center(
      child: Text(
        'No Expense Found !!',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainPageContent = ExpenseList(expenses: _registeredExpenses, onRemoveExpense: removeExistingExpense);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [IconButton(onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))],
      ),

      // Main UI Stack.
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          const SizedBox(height: 20),
          Expanded(child: mainPageContent),
        ],
      ),
    );
  }
}
