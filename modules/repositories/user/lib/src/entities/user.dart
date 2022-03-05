import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  const User({
    required this.id,
    required this.username,
    this.name,
    this.phone,
    this.email,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  final String id;

  final String username;

  final String? name;

  final String? phone;

  final String? email;

  final String? image;
}
