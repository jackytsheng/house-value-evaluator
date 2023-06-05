import 'package:house_evaluator/components/criteria_item.dart';
import 'package:house_evaluator/model/criteria_item.dart';
import 'package:uuid/uuid.dart';

enum PropertyType { townHouse, house, apartment }

enum PriceState { estimated, sold }

enum PropertyAction { newProperty, editProperty }

class Price {
  PriceState state;
  double amount;

  Price(this.state, this.amount);
}

class HouseAssessment {
  final String criteriaId;
  final String criteriaName;
  final double criteriaWeight;
  int score;
  List<NoteItem> comments;

  HouseAssessment(this.criteriaId, this.criteriaName, this.criteriaWeight,
      this.score, this.comments);
}

class HouseEntity {
  String houseId;
  String address;
  Price price;
  PropertyType propertyType;
  Map<String, HouseAssessment> houseAssessmentMap;

  HouseEntity(this.houseId, this.address, this.price, this.propertyType,
      this.houseAssessmentMap);

  double getOverAllScore() {
    double score = 0.0;
    houseAssessmentMap.values.forEach((assessment) {
      score += assessment.criteriaWeight * assessment.score;
    });
    return score;
  }
}
