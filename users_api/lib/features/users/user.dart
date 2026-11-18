class Geo {
  const Geo({required this.lat, required this.lng});
  final double lat;
  final double lng;

  factory Geo.fromJson(Map<String, dynamic> j) => Geo(
        lat: double.parse(j['lat'] as String),
        lng: double.parse(j['lng'] as String),
      );

  Map<String, dynamic> toJson() =>
      {'lat': lat.toString(), 'lng': lng.toString()};
  @override
  bool operator ==(Object o) => o is Geo && o.lat == lat && o.lng == lng;
  @override
  int get hashCode => Object.hash(lat, lng);
}

class Address {
  const Address(
      {required this.street,
      required this.suite,
      required this.city,
      required this.zipcode,
      required this.geo});
  final String street, suite, city, zipcode;
  final Geo geo;

  factory Address.fromJson(Map<String, dynamic> j) => Address(
        street: j['street'] as String,
        suite: j['suite'] as String,
        city: j['city'] as String,
        zipcode: j['zipcode'] as String,
        geo: Geo.fromJson(j['geo'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'street': street,
        'suite': suite,
        'city': city,
        'zipcode': zipcode,
        'geo': geo.toJson(),
      };
  @override
  bool operator ==(Object o) =>
      o is Address &&
      o.street == street &&
      o.suite == suite &&
      o.city == city &&
      o.zipcode == zipcode &&
      o.geo == geo;
  @override
  int get hashCode => Object.hash(street, suite, city, zipcode, geo);
}

class User {
  const User(
      {required this.id,
      required this.name,
      required this.username,
      required this.email,
      required this.phone,
      required this.website,
      required this.address,
      required this.company});
  final int id;
  final String name, username, email, phone;
  final String? website;
  final Address address;
  final ({String name, String catchPhrase}) company;

  String get phoneDigits => phone.replaceAll(RegExp(r'[^0-9+]'), '');

  factory User.fromJson(Map<String, dynamic> j) {
    final c = j['company'] as Map<String, dynamic>;
    return User(
      id: j['id'] as int,
      name: j['name'] as String,
      username: j['username'] as String,
      email: j['email'] as String,
      phone: j['phone'] as String,
      website: j['website'] as String?,
      address: Address.fromJson(j['address'] as Map<String, dynamic>),
      company: (
        name: c['name'] as String,
        catchPhrase: c['catchPhrase'] as String
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
        'phone': phone,
        'website': website,
        'address': address.toJson(),
        'company': {'name': company.name, 'catchPhrase': company.catchPhrase},
      };
  @override
  bool operator ==(Object o) => o is User && o.id == id;
  @override
  int get hashCode => id.hashCode;
  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}
