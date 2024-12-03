import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediationapp/core/themes/colors.dart';
import 'package:mediationapp/core/utils/error_text.dart';
import 'package:mediationapp/core/utils/loader.dart';
import 'package:mediationapp/feature/quotes/controller.dart';
import 'package:mediationapp/widgets/quotes_widget.dart';

class QuotesScreen extends ConsumerWidget {
  const QuotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          'Inspirational Quotes',
          style: TextStyle(
              color: AppColors.textIcons,
              fontSize: 26,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: ref.watch(getQuotesProvider).when(
          data: (data) {
            if (data.isEmpty) {
              return const ErrorText(text: 'No data found');
            }
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return QuoteWidget(quote: data[index]);
                });
          },
          error: (error, s) => ErrorText(text: error.toString()),
          loading: () => const Loader()),
    );
  }
}
