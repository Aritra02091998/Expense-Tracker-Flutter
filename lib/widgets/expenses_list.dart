import 'package:flutter/material.dart';
import 'package:expense_tracker/model/expense_blueprint.dart';
import 'package:expense_tracker/widgets/expenses_list_item.dart';

class ExpenseList extends StatelessWidget {

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  const ExpenseList({
    super.key, 
    required this.expenses, 
    required this.onRemoveExpense
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length, 
      itemBuilder: (ctx, index) {
        return Dismissible(
          background: Container(
            color: Theme.of(context).colorScheme.error.withAlpha(191),
            margin: const EdgeInsets.symmetric(horizontal: 16) ,
          ),
          key: ValueKey(expenses[index]),
          onDismissed: (direction) {
            onRemoveExpense(expenses[index]);
          },
          child: ExpenseListItem(eachExpenseItem: expenses[index]),
        );
      },
    );
  }
}
