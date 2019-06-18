import 'package:bloc/bloc.dart';

export 'package:bloc/bloc.dart';
export 'package:flutter_bloc/flutter_bloc.dart';

class FavorateBloc extends Bloc<List<String>, List<String>> {
  @override
  List<String> get initialState => [];

  @override
  Stream<List<String>> mapEventToState(List<String> event) async* {
    // 这里对事件的处理和bloc demo不一样，我们需要传递数据，所以event即是我们的数据；
    // 只有当我们需要传递一个事件，然后我们要做一些其他操作时，才使用bloc demo 中switch(event)的那种方式
    yield event;
  }
}
