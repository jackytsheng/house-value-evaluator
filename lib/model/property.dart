import 'package:property_evaluator/model/criteria.dart';

enum PropertyType { townHouse, house, apartment }

enum PriceState { estimated, sold }

enum PropertyAction { newProperty, editProperty }

PriceState priceStateFromString(String value) {
  switch (value) {
    case 'PriceState.estimated':
      return PriceState.estimated;
    case 'PriceState.sold':
      return PriceState.sold;
    default:
      throw Exception('Invalid PriceState');
  }
}

PropertyType propertyTypeFromString(String value) {
  switch (value) {
    case 'PropertyType.townHouse':
      return PropertyType.townHouse;
    case 'PropertyType.house':
      return PropertyType.house;
    case 'PropertyType.apartment':
      return PropertyType.apartment;
    default:
      throw Exception('Invalid PropertyType');
  }
}

class Price {
  PriceState state;
  double amount;

  Price(this.state, this.amount);

  Map<String, dynamic> toJson() {
    return {
      'state': state.toString(),
      'amount': amount,
    };
  }

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      priceStateFromString(json['state']),
      json['amount'],
    );
  }
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

  Map<String, dynamic> toJson() {
    return {
      'criteriaId': criteriaId,
      'notes': notes.map((note) => note.toJson()).toList(),
      'criteriaName': criteriaName,
      'weighting': weighting,
      'score': score,
    };
  }

  factory PropertyAssessment.fromJson(Map<String, dynamic> json) {
    return PropertyAssessment(
      json['criteriaId'],
      (json['notes'] as List<dynamic>)
          .map((noteJson) => NoteItem.fromJson(noteJson))
          .toList(),
      json['criteriaName'],
      json['weighting'],
      json['score'],
    );
  }
}

class PropertyEntity {
  String propertyId;
  String address;
  Price price;
  PropertyType propertyType;
  bool isSelected;
  Map<String, PropertyAssessment> propertyAssessmentMap;

  PropertyEntity(this.propertyId, this.address, this.price, this.propertyType,
      this.propertyAssessmentMap, this.isSelected);

  double getOverAllScore() {
    double score = 0.0;
    for (var assessment in propertyAssessmentMap.values) {
      score += assessment.weighting * assessment.score;
    }
    return score;
  }

  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'address': address,
      'price': price.toJson(),
      'propertyType': propertyType.toString(),
      'propertyAssessmentMap': propertyAssessmentMap
          .map((key, value) => MapEntry(key, value.toJson())),
      'isSelected': isSelected,
    };
  }

  factory PropertyEntity.fromJson(Map<String, dynamic> json) {
    return PropertyEntity(
        json['propertyId'],
        json['address'],
        Price.fromJson(json['price']),
        propertyTypeFromString(json['propertyType']),
        (json['propertyAssessmentMap'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, PropertyAssessment.fromJson(value)),
        ),
        json['isSelected']);
  }
}
