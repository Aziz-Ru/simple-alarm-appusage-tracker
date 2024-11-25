import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:mediationapp/core/constants/constants.dart';
import 'package:mediationapp/core/utils/failure.dart';
import 'package:mediationapp/core/utils/type_def.dart';
import 'package:mediationapp/feature/quotes/quote_model.dart';

final quotesRepositoryProvider =
    Provider((ref) => QuotesRepository(baseurl: Constants.baseUrl));

class QuotesRepository {
  final String baseurl;

  QuotesRepository({required this.baseurl});

  FutureEither<List<QuoteModel>> fetchQuotes() async {
    try {
      final response = await http.get(Uri.parse('$baseurl/quotes'));
      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);

        final List<QuoteModel> quotes = body
            .map((item) => QuoteModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return right(quotes);
      }
      throw Exception('Failed to load quotes');
    } catch (e) {
      // log(e.toString());
      return left(Failure(message: e.toString()));
    }
  }

  FutureEither<QuoteModel> getTodayQuote() async {
    try {
      final response = await http.get(Uri.parse('$baseurl/today'));
      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        // log(body[0].toString());
        final QuoteModel quote = QuoteModel.fromJson(body[0]);
        return right(quote);
      }
      throw Exception('Failed to load quotes');
    } catch (e) {
      // log(e.toString());
      return left(Failure(message: e.toString()));
    }
  }
}
