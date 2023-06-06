import 'package:house_evaluator/model/criteria.dart';

enum PropertyType { townHouse, house, apartment }

enum PriceState { estimated, sold }

enum PropertyAction { newProperty, editProperty }

class Price {
  PriceState state;
  double amount;

  Price(this.state, this.amount);
}

class PropertyAssessment {
  String criteriaId;
  String criteriaName;
  double criteriaWeight;
  int score;
  List<NoteItem> comments;

  PropertyAssessment(this.criteriaId, this.criteriaName, this.criteriaWeight,
      this.score, this.comments);
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
    propertyAssessmentMap.values.forEach((assessment) {
      score += assessment.criteriaWeight * assessment.score;
    });
    return score;
  }
}
