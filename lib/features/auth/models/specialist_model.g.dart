// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpecialistModelImpl _$$SpecialistModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SpecialistModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$$SpecialistModelImplToJson(
        _$SpecialistModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
    };
