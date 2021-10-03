class DollarBill {
  final String serialNb, amount;
  String? seriesYear,reserveBank ;

  DollarBill(
      {required this.serialNb,
       this.reserveBank,
      this.seriesYear,
      required this.amount});
}
