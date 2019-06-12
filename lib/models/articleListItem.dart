import 'package:json_annotation/json_annotation.dart';
import "tag.dart";
part 'articleListItem.g.dart';

@JsonSerializable()
class ArticleListItem {
    ArticleListItem();

    String apkLink;
    String author;
    num chapterId;
    String chapterName;
    bool collect;
    num courseId;
    String desc;
    String envelopePic;
    bool fresh;
    num id;
    String link;
    String niceDate;
    String origin;
    String prefix;
    String projectLink;
    num publishTime;
    num superChapterId;
    String superChapterName;
    List<Tag> tags;
    String title;
    num type;
    num userId;
    num visible;
    num zan;
    
    factory ArticleListItem.fromJson(Map<String,dynamic> json) => _$ArticleListItemFromJson(json);
    Map<String, dynamic> toJson() => _$ArticleListItemToJson(this);
}
