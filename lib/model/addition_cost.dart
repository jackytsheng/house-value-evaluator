import 'package:uuid/uuid.dart';

enum CostType { percentage, amount }

class AdditionalCostEntity {
  String costItemId = Uuid().v4();
  String costName;
  double weighting;
  CostType costType;
  double cost;

  AdditionalCostEntity(this.weighting, this.costName, this.costType, this.cost);
}
