import 'package:property_evaluator/model/criteria.dart';
import 'package:property_evaluator/model/note.dart';

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

  Price({required this.state, required this.amount});

  Map<String, dynamic> toJson() {
    return {
      'state': state.toString(),
      'amount': amount,
    };
  }

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      state: priceStateFromString(json['state']),
      amount: json['amount'],
    );
  }
}

class PropertyAssessment extends CriteriaItemEntity {
  int score;

  PropertyAssessment(
      {required super.criteriaId,
      required super.notes,
      required super.criteriaName,
      required super.weighting,
      this.score = 0});

  @override
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
      criteriaId: json['criteriaId'],
      notes: (json['notes'] as List<dynamic>)
          .map((noteJson) => NoteItem.fromJson(noteJson))
          .toList(),
      criteriaName: json['criteriaName'],
      weighting: json['weighting'],
      score: json['score'],
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

  PropertyEntity(
      {required this.propertyId,
      this.address = "",
      required this.price,
      this.propertyType = PropertyType.house,
      required this.propertyAssessmentMap,
      this.isSelected = false});

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
        propertyId: json['propertyId'],
        address: json['address'],
        price: Price.fromJson(json['price']),
        propertyType: propertyTypeFromString(json['propertyType']),
        propertyAssessmentMap:
            (json['propertyAssessmentMap'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, PropertyAssessment.fromJson(value)),
        ),
        isSelected: json['isSelected']);
  }
}
