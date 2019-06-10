// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Persion _$PersionFromJson(Map<String, dynamic> json) {
  return Persion()
    ..name = json['name'] as String
    ..age = json['age'] as num
    ..email = json['email'] as String;
}

Map<String, dynamic> _$PersionToJson(Persion instance) => <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
      'email': instance.email
    };
