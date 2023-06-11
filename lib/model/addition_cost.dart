enum CostType { percentage, plain }

String costTypeToString(CostType costType) {
  switch (costType) {
    case CostType.percentage:
      return 'percentage';
    case CostType.plain:
      return 'plain';
    default:
      throw Exception('Invalid CostType');
  }
}

CostType costTypeFromString(String value) {
  switch (value) {
    case 'percentage':
      return CostType.percentage;
    case 'plain':
      return CostType.plain;
    default:
      throw Exception('Invalid CostType');
  }
}

class AdditionalCostEntity {
  String costItemId;
  String costName;
  CostType costType;
  double amount;

  AdditionalCostEntity(
      {required this.costItemId,
      required this.costType,
      this.costName = "",
      this.amount = 0});

  Map<String, dynamic> toJson() {
    return {
      'costItemId': costItemId,
      'costName': costName,
      'costType': costTypeToString(costType),
      'amount': amount,
    };
  }

  factory AdditionalCostEntity.fromJson(Map<String, dynamic> json) {
    return AdditionalCostEntity(
      costItemId: json['costItemId'],
      costName: json['costName'],
      costType: costTypeFromString(json['costType']),
      amount: json['amount'],
    );
  }
}
