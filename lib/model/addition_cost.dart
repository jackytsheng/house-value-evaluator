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
      this.costItemId, this.costName, this.costType, this.amount);

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
      json['costItemId'],
      json['costName'],
      costTypeFromString(json['costType']),
      json['amount'],
    );
  }
}
