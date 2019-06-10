import 'package:dio/dio.dart';
import 'dart:convert';
export 'package:dio/dio.dart';
// dio 使用教程：https://book.flutterchina.club/chapter10/dio.html
final Dio dio = new Dio();
// 免费的api接口：https://www.wanandroid.com/article/list/1/json

// 获取JSON
Future<Response> getFreeJson(int index) => dio.get('https://www.wanandroid.com/article/list/$index/json');
