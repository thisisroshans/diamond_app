class Diamond {
  final String? lotId;
   int qty;
  final double? carat;
  final String? size;
  final String? lab;
  final String? shape;
  final String? color;
  final String? clarity;
  final String? cut;
  final String? polish;
  final String? symmetry;
  final String? fluorescence;
  final double? discount;
  final double? perCaratRate;
  final double? finalAmount;
  Diamond({
    this.lotId,
    this.qty = 0,
    this.carat,
    this.size,
    this.lab,
    this.shape,
    this.color,
    this.clarity,
    this.cut,
    this.polish,
    this.symmetry,
    this.fluorescence,
    this.discount,
    this.perCaratRate,
    this.finalAmount,
  });

  /// **Factory constructor to create a [Diamond] object from JSON.**
  factory Diamond.fromJson(Map<String, dynamic> json) {
    return Diamond(
      lotId: _convertToNullableString(json['Lot Id']),
      qty: _convertToNullableInt(json['Qty']) ?? 0,
      carat: _convertToNullableDouble(json['Carat']),
      size: _convertToNullableString(json['Size']),
      lab: _convertToNullableString(json['Lab']),
      shape: _convertToNullableString(json['Shape']),
      color: _convertToNullableString(json['Color']),
      clarity: _convertToNullableString(json['Clarity']),
      cut: _convertToNullableString(json['Cut']),
      polish: _convertToNullableString(json['Polish']),
      symmetry: _convertToNullableString(json['Symmetry']),
      fluorescence: _convertToNullableString(json['Fluorescence']),
      discount: _convertToNullableDouble(json['Discount']),
      perCaratRate: _convertToNullableDouble(json['Per Carat Rate']),
      finalAmount: _convertToNullableDouble(json['Final Amount']),
    );
  }

  /// **Converts a [Diamond] object to a JSON-compatible Map.**
  Map<String, dynamic> toJson() {
    return {
      'Lot Id': lotId,
      'Qty': qty,
      'Carat': carat,
      'Size': size,
      'Lab': lab,
      'Shape': shape,
      'Color': color,
      'Clarity': clarity,
      'Cut': cut,
      'Polish': polish,
      'Symmetry': symmetry,
      'Fluorescence': fluorescence,
      'Discount': discount,
      'Per Carat Rate': perCaratRate,
      'Final Amount': finalAmount,
    };
  }

  /// **Helper Methods for Safe Parsing**
  static String? _convertToNullableString(dynamic value) {
    return (value is String && value.trim().isNotEmpty) ? value : null;
  }

  static int? _convertToNullableInt(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return null;
    return int.tryParse(value.toString());
  }

  static double? _convertToNullableDouble(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return null;
    return double.tryParse(value.toString());
  }

  Diamond copyWith({int quantity = 0}) {
    return Diamond(
        carat: carat,
        size: size,
        shape: shape,
        color: color,
        clarity: clarity,
        cut: cut,
        polish: polish,
        symmetry: symmetry,
        fluorescence: fluorescence,
        discount: discount,
        perCaratRate: perCaratRate,
        finalAmount: finalAmount,
        qty: quantity);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Diamond && other.lotId == lotId);

  @override
  int get hashCode => lotId.hashCode;
}
