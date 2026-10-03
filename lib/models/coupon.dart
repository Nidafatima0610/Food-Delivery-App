class Coupon {
  final String code;
  final double discountValue;
  final bool isPercentage;
  final double minOrderAmount;
  final String title;
  final String description;

  Coupon({
    required this.code,
    required this.discountValue,
    required this.isPercentage,
    required this.minOrderAmount,
    this.title = '',
    this.description = '',
  });
}
