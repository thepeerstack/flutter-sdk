import 'dart:convert';

import 'package:equatable/equatable.dart';

class ThePeerAppListModel with EquatableMixin {
  final List<ThePeerBusiness>? businesses;
  ThePeerAppListModel({
    required this.businesses,
  });

  ThePeerAppListModel copyWith({
    List<ThePeerBusiness>? businesses,
  }) {
    return ThePeerAppListModel(
      businesses: businesses ?? this.businesses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'businesses': businesses?.map((x) => x.toMap()).toList(),
    };
  }

  factory ThePeerAppListModel.fromMap(Map<String, dynamic> map) {
    return ThePeerAppListModel(
      businesses: List<ThePeerBusiness>.from(
          map['businesses']?.map((x) => ThePeerBusiness.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ThePeerAppListModel.fromJson(String source) =>
      ThePeerAppListModel.fromMap(json.decode(source));

  @override
  String toString() => 'ThePeerAppListModel(businesses: $businesses)';

  @override
  int get hashCode => businesses.hashCode;

  @override
  List<Object> get props => [businesses ?? ''];
}

class ThePeerBusiness with EquatableMixin {
  final String id;
  final String name;
  final String email;
  final String? logo;
  final String identifier_type;
  ThePeerBusiness({
    required this.id,
    required this.name,
    required this.email,
    required this.logo,
    required this.identifier_type,
  });

  ThePeerBusiness copyWith({
    String? id,
    String? name,
    String? email,
    String? logo,
    String? identifier_type,
  }) {
    return ThePeerBusiness(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      logo: logo ?? this.logo,
      identifier_type: identifier_type ?? this.identifier_type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'logo': logo,
      'identifier_type': identifier_type,
    };
  }

  factory ThePeerBusiness.fromMap(Map<String, dynamic> map) {
    return ThePeerBusiness(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      logo: map['logo'],
      identifier_type: map['identifier_type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ThePeerBusiness.fromJson(String source) =>
      ThePeerBusiness.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Business(id: $id, name: $name, email: $email, logo: $logo, identifier_type: $identifier_type)';
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      email,
      logo ?? '',
      identifier_type,
    ];
  }
}
