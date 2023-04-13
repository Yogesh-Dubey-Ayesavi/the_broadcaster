// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BroadCast _$BroadCastFromJson(Map<String, dynamic> json) => BroadCast(
      json['message'] as String,
      recipients: (json['recipients'] as List<dynamic>?)
              ?.map((e) => Contact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] as int,
      id: json['id'] as String,
    );

Map<String, dynamic> _$BroadCastToJson(BroadCast instance) => <String, dynamic>{
      'recipients': instance.recipients,
      'message': instance.message,
      'createdAt': instance.createdAt,
      'id': instance.id,
    };
