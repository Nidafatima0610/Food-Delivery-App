class Coupon {
  final String code;
  final double discountValue;
  final bool isPercentage;
  final double minOrderAmount;

  Coupon({
    required this.code,
    required this.discountValue,
    required this.isPercentage,
    required this.minOrderAmount,
  });
}
