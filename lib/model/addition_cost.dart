enum CostType { percentage, plain }

class AdditionalCostEntity {
  String costItemId;
  String costName;
  CostType costType;
  double amount;

  AdditionalCostEntity(
      this.costItemId, this.costName, this.costType, this.amount);
}
