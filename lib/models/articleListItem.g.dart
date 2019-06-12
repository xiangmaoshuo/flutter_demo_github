// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'articleListItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleListItem _$ArticleListItemFromJson(Map<String, dynamic> json) {
  return ArticleListItem()
    ..author = json['author'] as String
    ..link = json['link'] as String
    ..niceDate = json['niceDate'] as String
    ..title = json['title'] as String;
}

Map<String, dynamic> _$ArticleListItemToJson(ArticleListItem instance) =>
    <String, dynamic>{
      'author': instance.author,
      'link': instance.link,
      'niceDate': instance.niceDate,
      'title': instance.title
    };
