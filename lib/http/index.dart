import 'package:dio/dio.dart';
import '../models/index.dart'; // JSON MODEL

export 'package:dio/dio.dart'; // 导出dio变量，以供页面调用
export '../models/index.dart'; // JSON MODEL

part './modules/demo.dart';
/*
 * dio的拦截器处理规则经测试后总结为：
 * 三个回调onRequest，onResponse，onError如果没有返回值，则使用之前传入的给它们的参数作为返回值继续往下传递，以供then，catch使用。
 * 
 * 在所有拦截器中，你都可以改变请求执行流， 如果你想完成请求/响应并返回自定义数据，你可以返回一个 `Response` 对象或返回 `dio.resolve(data)`的结果。
 * 如果你想终止(触发一个错误，上层`catchError`会被调用)一个请求/响应，那么可以返回一个`DioError` 对象或返回 `dio.reject(errMsg)` 的结果.
 */

/*
 * 对于Future来说，它的then和catch本身的作用和Promise是一样的，当添加了then/onError/catch之类的回调时，Future就认为该Future默认是成功了，
 * 后续的then链则会正常进行，参数为上述回调的返回值，如果想让onError/catch的错误继续传递，则需要throw。
 * 所以这里的dio和Future的区别就是：
 *  1. dio在处理回调时如果没有返回值，则会使用之前的值，future则会默认返回值为null；
 *  2. dio在有返回值的情况下，如果是返回的DioError/dio.reject()则会进入catch流，而Future不会，future需要显示throw 抛出错误
 */

final _dioInstance = new Dio()
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (RequestOptions options) {
      return options;
    },
    onResponse: (Response response) {
      return response.data['data'] as Map;
    },
    onError: (DioError error) {
      switch (error.response.statusCode) {
        case 404:
          print('资源未找到');
          break;
      }
    }
  ));