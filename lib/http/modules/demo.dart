part of '../index.dart';

// 免费的api接口：https://www.wanandroid.com/article/list/1/json

// 获取JSON
Future<ArticleList> getFreeJson(int page) => _dioInstance.get<Map>('https://www.wanandroid.com/article/list/$page/json').then(
  (res) => ArticleList.fromJson(res.data['data'])
);

// 免费api（干货集中营）：http://gank.io/api/today
Future<List<String>> getGankJson() => _dioInstance.get<Map>('http://gank.io/api/data/%E7%A6%8F%E5%88%A9/1000/1').then(
  (res) => (res.data['results'] as List).map((item) => item['url'] as String).toList()
);