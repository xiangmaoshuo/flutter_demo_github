import 'package:json_annotation/json_annotation.dart';

part 'articleListItem.g.dart';

@JsonSerializable()
class ArticleListItem {
    ArticleListItem();

    String author;
    String link;
    String niceDate;
    String title;
    
    factory ArticleListItem.fromJson(Map<String,dynamic> json) => _$ArticleListItemFromJson(json);
    Map<String, dynamic> toJson() => _$ArticleListItemToJson(this);
}
