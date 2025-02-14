import 'package:freezed_annotation/freezed_annotation.dart';

part 'specialist_model.freezed.dart';
part 'specialist_model.g.dart';

@freezed
class SpecialistModel with _$SpecialistModel {
  const factory SpecialistModel({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
  }) = _SpecialistModel;

  factory SpecialistModel.fromJson(Map<String, dynamic> json) =>
      _$SpecialistModelFromJson(json);
}
