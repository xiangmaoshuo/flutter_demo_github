import 'package:json_annotation/json_annotation.dart';

part 'persion.g.dart';

@JsonSerializable()
class Persion {
    Persion();

    String name;
    num age;
    String email;
    
    factory Persion.fromJson(Map<String,dynamic> json) => _$PersionFromJson(json);
    Map<String, dynamic> toJson() => _$PersionToJson(this);
}
