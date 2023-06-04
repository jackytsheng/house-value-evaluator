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
  String criteriaName;
  double criteriaWeight;
  int score;
  List<NoteItem> comments;

  HouseAssessment(
      this.criteriaName, this.criteriaWeight, this.score, this.comments);
}

class HouseCardEntity {
  String houseId = Uuid().v4();
  String address;
  Price price;
  PropertyType propertyType;
  List<HouseAssessment> houseAssessment;

  HouseCardEntity(
      this.address, this.price, this.propertyType, this.houseAssessment);

  double getOverAllScore() {
    double score = 0.0;
    houseAssessment.forEach((assessment) {
      score += assessment.criteriaWeight * assessment.score;
    });
    return score;
  }
}
