import 'package:json_annotation/json_annotation.dart';
import "articleListItem.dart";
part 'articleList.g.dart';

@JsonSerializable()
class ArticleList {
    ArticleList();

    num curPage;
    num offset;
    bool over;
    num pageCount;
    num size;
    num total;
    List<ArticleListItem> datas;
    
    factory ArticleList.fromJson(Map<String,dynamic> json) => _$ArticleListFromJson(json);
    Map<String, dynamic> toJson() => _$ArticleListToJson(this);
}
