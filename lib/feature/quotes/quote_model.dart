class QuoteModel {
  final String q;
  final String a;
  final String c;
  final String h;

  QuoteModel({
    required this.q,
    required this.a,
    required this.c,
    required this.h,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      q: json['q'],
      a: json['a'],
      c: json['c'] ?? '',
      h: json['h'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'q': q,
      'a': a,
      'c': c,
      'h': h,
    };
  }
}
