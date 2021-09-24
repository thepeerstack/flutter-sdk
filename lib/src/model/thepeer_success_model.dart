import 'dart:convert';

import 'package:equatable/equatable.dart';

class ThepeerSuccessModel with EquatableMixin {
  final String type;
  final ThepeerSuccessData data;
  ThepeerSuccessModel({
    required this.type,
    required this.data,
  });

  ThepeerSuccessModel copyWith({
    String? type,
    ThepeerSuccessData? data,
  }) {
    return ThepeerSuccessModel(
      type: type ?? this.type,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'data': data.toMap(),
    };
  }

  factory ThepeerSuccessModel.fromMap(Map<String, dynamic> map) {
    return ThepeerSuccessModel(
      type: map['type'],
      data: ThepeerSuccessData.fromMap(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ThepeerSuccessModel.fromJson(String source) =>
      ThepeerSuccessModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [type, data];
}

class ThepeerSuccessData with EquatableMixin {
  final String id;
  final String remark;
  final int amount;
  final String type;
  final bool directDebit;
  final String status;
  final User user;
  final String mode;
  final String reference;
  final Peer peer;
  final String createdAt;
  final String updatedAt;

  ThepeerSuccessData({
    required this.id,
    required this.remark,
    required this.amount,
    required this.type,
    required this.directDebit,
    required this.status,
    required this.user,
    required this.mode,
    required this.reference,
    required this.peer,
    required this.createdAt,
    required this.updatedAt,
  });

  ThepeerSuccessData copyWith({
    String? id,
    String? remark,
    int? amount,
    String? type,
    bool? directDebit,
    String? status,
    User? user,
    String? mode,
    String? reference,
    Peer? peer,
    String? createdAt,
    String? updatedAt,
  }) {
    return ThepeerSuccessData(
      id: id ?? this.id,
      remark: remark ?? this.remark,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      directDebit: directDebit ?? this.directDebit,
      status: status ?? this.status,
      user: user ?? this.user,
      mode: mode ?? this.mode,
      reference: reference ?? this.reference,
      peer: peer ?? this.peer,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'remark': remark,
      'amount': amount,
      'type': type,
      'direct_debit': directDebit,
      'status': status,
      'user': user.toMap(),
      'mode': mode,
      'reference': reference,
      'peer': peer.toMap(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory ThepeerSuccessData.fromMap(Map<String, dynamic> map) {
    return ThepeerSuccessData(
      id: map['id'],
      remark: map['remark'],
      amount: map['amount'],
      type: map['type'],
      directDebit: map['direct_debit'],
      status: map['status'],
      user: User.fromMap(map['user']),
      mode: map['mode'],
      reference: map['reference'],
      peer: Peer.fromMap(map['peer']),
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ThepeerSuccessData.fromJson(String source) =>
      ThepeerSuccessData.fromMap(
        json.decode(source),
      );

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      remark,
      amount,
      type,
      directDebit,
      status,
      user,
      mode,
      reference,
      peer,
      createdAt,
      updatedAt,
    ];
  }
}

class User with EquatableMixin {
  final String name;
  final String identifier;
  final String identifierType;
  final String email;
  final String reference;
  final String createdAt;
  final String updatedAt;
  User({
    required this.name,
    required this.identifier,
    required this.identifierType,
    required this.email,
    required this.reference,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? name,
    String? identifier,
    String? identifierType,
    String? email,
    String? reference,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      name: name ?? this.name,
      identifier: identifier ?? this.identifier,
      identifierType: identifierType ?? this.identifierType,
      email: email ?? this.email,
      reference: reference ?? this.reference,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'identifier': identifier,
      'identifier_type': identifierType,
      'email': email,
      'reference': reference,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      identifier: map['identifier'],
      identifierType: map['identifier_type'],
      email: map['email'],
      reference: map['reference'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      name,
      identifier,
      identifierType,
      email,
      reference,
      createdAt,
      updatedAt,
    ];
  }
}

class Peer with EquatableMixin {
  final Business business;
  final User user;
  Peer({
    required this.business,
    required this.user,
  });

  Peer copyWith({
    Business? business,
    User? user,
  }) {
    return Peer(
      business: business ?? this.business,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'business': business.toMap(),
      'user': user.toMap(),
    };
  }

  factory Peer.fromMap(Map<String, dynamic> map) {
    return Peer(
      business: Business.fromMap(map['business']),
      user: User.fromMap(map['user']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Peer.fromJson(String source) => Peer.fromMap(json.decode(source));

  @override
  List<Object> get props => [business, user];
}

class Business with EquatableMixin {
  final String id;
  final String name;
  final String logo;
  final String logoColour;
  final String identifierType;
  Business({
    required this.id,
    required this.name,
    required this.logo,
    required this.logoColour,
    required this.identifierType,
  });

  Business copyWith({
    String? id,
    String? name,
    String? logo,
    String? logoColour,
    String? identifierType,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      logoColour: logoColour ?? this.logoColour,
      identifierType: identifierType ?? this.identifierType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'logo_colour': logoColour,
      'identifier_type': identifierType,
    };
  }

  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(
      id: map['id'],
      name: map['name'],
      logo: map['logo'],
      logoColour: map['logo_colour'],
      identifierType: map['identifier_type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Business.fromJson(String source) =>
      Business.fromMap(json.decode(source));

  @override
  bool? get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      logo,
      logoColour,
      identifierType,
    ];
  }
}
