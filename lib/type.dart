enum PropertyType { townHouse, house }

enum PriceState { estimated, sold }

class Price {
  PriceState state;
  double amount;

  Price(this.state, this.amount);
}

class HouseCard {
  String address;
  double overallScore;
  Price price;
  PropertyType propertyType;

  HouseCard(this.address, this.overallScore, this.price, this.propertyType);
}
