// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  Contact(this.phoneNumber, {this.name, required this.fileName});

  final String? name;

  final String phoneNumber;

  final String fileName;

  final ValueNotifier<bool> isSelected = ValueNotifier(false);

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
  Map<String, dynamic> toJson() => _$ContactToJson(this);

  void toggleIsSelected(bool val) {
    isSelected.value = val;
  }

  // Contact copyWith({
  //   String? name,
  //   String? phoneNumber,
  //   String? fileName,
  // }) {
  //   return Contact(
  //     phoneNumber ?? this.phoneNumber,
  //     name: name ?? this.name,
  //     fileName: fileName ?? this.fileName,
  //   );
  // }
}
