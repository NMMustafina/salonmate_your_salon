class IncomeEntry {
  final int id;
  final String masterName;
  final String service;
  final double amount;
  final DateTime date;

  IncomeEntry({
    required this.id,
    required this.masterName,
    required this.service,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'masterName': masterName,
        'service': service,
        'amount': amount,
        'date': date.toIso8601String(),
      };

  factory IncomeEntry.fromJson(Map<String, dynamic> json) => IncomeEntry(
        id: json['id'],
        masterName: json['masterName'],
        service: json['service'],
        amount: json['amount'],
        date: DateTime.parse(json['date']),
      );
}
