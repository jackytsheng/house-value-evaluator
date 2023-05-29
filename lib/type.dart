enum PropertyType { townHouse, house, apartment }

enum PriceState { estimated, sold }

class Price {
  PriceState state;
  double amount;

  Price(this.state, this.amount);
}

class HouseCardProps {
  String address;
  double overallScore;
  Price price;
  PropertyType propertyType;

  HouseCardProps(
      this.address, this.overallScore, this.price, this.propertyType);
}
