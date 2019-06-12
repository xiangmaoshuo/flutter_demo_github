part of '../index.dart';

// 免费的api接口：https://www.wanandroid.com/article/list/1/json

// 获取JSON
Future<ArticleList> getFreeJson(int page) => _dioInstance.get<Map>('https://www.wanandroid.com/article/list/$page/json').then(
  (res) => ArticleList.fromJson(res.data)
);
