import 'package:flutter/material.dart';
import 'package:mediationapp/core/themes/colors.dart';
import 'package:mediationapp/feature/quotes/quote_model.dart';

class QuoteWidget extends StatelessWidget {
  final QuoteModel quote;
  const QuoteWidget({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        border: Border.all(color: AppColors.textSecondary),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            "\"${quote.q}\"",
            style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '- By ${quote.a}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
            ],
          )
        ],
      ),
    );
  }
}
