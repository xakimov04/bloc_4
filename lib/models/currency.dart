class Currency {
  final String name;
  final double rate;

  Currency({required this.name, required this.rate});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      name: json['name'],
      rate: json['rate'],
    );
  }
}
