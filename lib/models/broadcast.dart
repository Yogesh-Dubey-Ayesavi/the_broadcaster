// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import 'contact.dart';

part 'broadcast.g.dart';

@JsonSerializable()
class BroadCast {
  BroadCast(this.message,
      {this.recipients = const [],
      required this.createdAt,
      required this.id,
      this.mappedContacts});

  List<Contact> recipients;
  final String message;
  final int createdAt;
  final String id;
  
  final ValueNotifier<bool> hasContactsLoaded = ValueNotifier(false);

  Map<String, List<Contact>>? mappedContacts;

  // Map<String,List<Contact>>


  factory BroadCast.fromJson(Map<String, dynamic> json) =>
      _$BroadCastFromJson(json);

  Map<String, dynamic> toJson() => _$BroadCastToJson(this);

  BroadCast copyWith(
      {String? phoneNumber,
      String? message,
      int? createdAt,
      String? id,
      List<Contact>? recipients,
      Map<String, List<Contact>>? mappedContacts}) {
    return BroadCast(message ?? this.message,
        recipients: recipients ?? this.recipients,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        mappedContacts: mappedContacts ?? this.mappedContacts);
  }
}
