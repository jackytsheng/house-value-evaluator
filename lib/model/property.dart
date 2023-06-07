import 'package:property_evaluator/model/criteria.dart';

enum PropertyType { townHouse, house, apartment }

enum PriceState { estimated, sold }

enum PropertyAction { newProperty, editProperty }

class Price {
  PriceState state;
  double amount;

  Price(this.state, this.amount);
}

class PropertyAssessment extends CriteriaItemEntity {
  int score;

  PropertyAssessment(String criteriaId, List<NoteItem> notes,
      String criteriaName, double criteriaWeight, this.score)
      : super(
          criteriaId,
          notes,
          criteriaName,
          criteriaWeight,
        );
}

class PropertyEntity {
  String propertyId;
  String address;
  Price price;
  PropertyType propertyType;
  Map<String, PropertyAssessment> propertyAssessmentMap;

  PropertyEntity(this.propertyId, this.address, this.price, this.propertyType,
      this.propertyAssessmentMap);

  double getOverAllScore() {
    double score = 0.0;
    for (var assessment in propertyAssessmentMap.values) {
      score += assessment.weighting * assessment.score;
    }
    return score;
  }
}
