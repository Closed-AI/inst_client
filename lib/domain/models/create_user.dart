import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_user.g.dart';

@JsonSerializable()
class CreateUser {
  final String name;
  final String email;
  final String password;
  final String retryPassword;
  final DateTime birthDate;

  const CreateUser(
      {required this.name,
      required this.email,
      required this.password,
      required this.retryPassword,
      required this.birthDate});

  factory CreateUser.fromJson(Map<String, dynamic> json) =>
      _$CreateUserFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserToJson(this);
}
