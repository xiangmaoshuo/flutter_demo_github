import 'package:bloc/bloc.dart';

export 'package:bloc/bloc.dart';
export 'package:flutter_bloc/flutter_bloc.dart';

/// [_StateDispatchBloc]是专门用于传递数据的[Bloc]，即[bloc.dispatch]所接收的参数就是我们的[State]
abstract class _StateDispatchBloc<T> extends Bloc<T, T> {
  _StateDispatchBloc(this._initialState) : super();

  final T _initialState;

  @override
  T get initialState => _initialState;

  @override
  Stream<T> mapEventToState(T state) async* {
    // 这里对事件的处理和bloc demo不一样，我们需要传递数据，所以event即是我们的数据；
    // 只有当我们需要传递一个事件，然后我们要做一些其他操作时，才使用bloc demo 中switch(event)的那种方式
    yield state;
  }
}

/// 首页-图片列表中双击可以全局保存当前用户喜欢的照片，并显示心型符号
class FavorateBloc extends _StateDispatchBloc<List<String>> {
  FavorateBloc(): super([]);
}
