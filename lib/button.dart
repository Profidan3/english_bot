import 'package:json_annotation/json_annotation.dart';

part 'button.g.dart';

@JsonSerializable()
class Button {
  String text = "";
  String callbackData = "";

  Button({required this.text, required this.callbackData});

  factory Button.fromJson(Map<String, dynamic> json) => _$ButtonFromJson(json);

  Map<String, dynamic> toJson() => _$ButtonToJson(this);
}
