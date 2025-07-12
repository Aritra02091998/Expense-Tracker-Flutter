import 'package:flutter/material.dart';
import 'package:expense_tracker/model/expense_blueprint.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense eachExpenseItem;

  const ExpenseListItem({super.key, required this.eachExpenseItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Expense title
            Text(
              eachExpenseItem.title, // Replace with eachExpenseItem.title
              style: Theme.of(context).textTheme.titleLarge,
            ),

            // Vertical space
            const SizedBox(height: 4.0),

            // Row containing Amount and ( Date & Category )
            Row(
              children: [

                // Expense Amount
                Text(
                  '\$${eachExpenseItem.amount.toStringAsFixed(2)}', // Replace with eachExpenseItem.amount
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary),
                ),

                // Spacer to push Date and Category to the right
                const Spacer(),

                // Row Group for Date and Category
                Row(
                  children: [
                    Icon(categoryIcons[eachExpenseItem.category]), 
                    const SizedBox(width: 8.0), 
                    Text(eachExpenseItem.formattedDate), 
                  ],
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
}
