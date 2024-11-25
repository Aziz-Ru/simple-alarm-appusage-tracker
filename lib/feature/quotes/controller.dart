import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mediationapp/feature/quotes/quote_model.dart';
import 'package:mediationapp/feature/quotes/repository.dart';

final quotesControllerProvider =
    StateNotifierProvider<QuotesController, bool>((ref) {
  final repository = ref.watch(quotesRepositoryProvider);
  return QuotesController(quotesrepository: repository);
});

final getQuotesProvider = FutureProvider<List<QuoteModel>>((ref) async {
  final controller = ref.watch(quotesControllerProvider.notifier);
  return controller.fetchQuotes();
});

final getTodayQuoteProvider = FutureProvider<QuoteModel>((ref) async {
  final controller = ref.watch(quotesControllerProvider.notifier);
  return controller.getTodayQuote();
});

class QuotesController extends StateNotifier<bool> {
  final QuotesRepository _quotesRepository;
  QuotesController({required QuotesRepository quotesrepository})
      : _quotesRepository = quotesrepository,
        super(false);
  Future<List<QuoteModel>> fetchQuotes() async {
    final result = await _quotesRepository.fetchQuotes();

    return result.fold((l) => [], (r) => r);
  }

  Future<QuoteModel> getTodayQuote() async {
    final result = await _quotesRepository.getTodayQuote();
    return result.fold(
        (l) => QuoteModel(
              q: "It's not the size of the dog in the fight, it's the size of the fight in the dog",
              a: 'Mark Twain',
              c: "US",
              h: "uidiid",
            ),
        (r) => r);
  }
}
