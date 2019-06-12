// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'articleList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleList _$ArticleListFromJson(Map<String, dynamic> json) {
  return ArticleList()
    ..curPage = json['curPage'] as num
    ..offset = json['offset'] as num
    ..over = json['over'] as bool
    ..pageCount = json['pageCount'] as num
    ..size = json['size'] as num
    ..total = json['total'] as num
    ..datas = (json['datas'] as List)
        ?.map((e) => e == null
            ? null
            : ArticleListItem.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ArticleListToJson(ArticleList instance) =>
    <String, dynamic>{
      'curPage': instance.curPage,
      'offset': instance.offset,
      'over': instance.over,
      'pageCount': instance.pageCount,
      'size': instance.size,
      'total': instance.total,
      'datas': instance.datas
    };
