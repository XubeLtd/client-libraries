class Address {
  String? city;
  String? country;
  String? postCode;
  String? state;
  String? streetAndNumber;

  Address({
    this.city,
    this.country,
    this.postCode,
    this.state,
    this.streetAndNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'country': country,
      'postCode': postCode,
      'state': state,
      'streetAndNumber': streetAndNumber,
    };
  }
}

class Location {
  Address? address;
  String? coordinateURL;
  String? name;

  Location({
    this.address,
    this.coordinateURL,
    this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address?.toJson(),
      'coordinateUrl': coordinateURL,
      'name': name,
    };
  }
}
