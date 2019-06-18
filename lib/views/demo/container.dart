import 'package:flutter/material.dart';
import 'package:flutter_demo/bloc/index.dart' show BlocBuilder, BlocProvider, FavorateBloc;
class ContainerDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FavorateBloc>(context);
    return Container(
        alignment: Alignment.centerLeft,
        child: Center(
          child: BlocBuilder(
            bloc: bloc,
            builder: (context, List<String> state) {
              List<Image> imgs;
              if (state.isEmpty) {
                imgs = [
                  Image(image: AssetImage('lib/images/demo.jpg'), width: 100, height: 100, colorBlendMode: BlendMode.color, color: Colors.pink,),
                  Image(image: AssetImage('lib/images/demo.jpg'), width: 100, height: 100, colorBlendMode: BlendMode.color, color: Colors.yellow,)
                ];
              } else {
                imgs = [
                  Image.network(state[0], width: 100, height: 100, colorBlendMode: BlendMode.color, color: Colors.pink),
                  Image.network(state.length > 1 ? state[1] : state[0], width: 100, height: 100, colorBlendMode: BlendMode.color, color: Colors.yellow)
                ];
              }
              return Row(children: imgs, mainAxisAlignment: MainAxisAlignment.spaceBetween);
            }
          )
        ),
        decoration: BoxDecoration(
          border: Border.all(width: 5, color: Colors.black45),
          // color: Colors.yellow,
          // borderRadius: BorderRadius.all(Radius.circular(8)),
          // image: DecorationImage(image: AssetImage('lib/images/demo.jpg'), fit: BoxFit.contain),
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: <Color>[Colors.pink, Colors.amber])
        ),
    );
  }
}
