# flutter_demo
## flutter学习demo，包含flutter相关的各种demo示例

1. 图片预览组件: `ScaleWidgetDemo`可以对图片进行缩放，移动查看
2. 图片加载组件：`PlaceHolderImageDemo`可以对图片添加loading动画，以及加载失败的error占位图
3. 移动端适配组件： `AdaptBuilder` 结合 `Adapt`可以得到一个单例实例，该实例能够满足移动端适配的需求
4. loading组件： `LoadingDemo`可以对传入的`loadingText`进行动画展示，可以用作文字loading动画
5. hero动画组件：`HeroPage`是简单的对flutter的`Hero`动画进行的封装
6. 以上为可以直接用于其他flutter项目的组件，本Demo项目中还对以下功能做了实践，读者可以用作参考。

- a. 基于`bloc`模式的响应式交互设计
- b. 基于`dio`的http、ajax数据请求实践
- c. 基于`json_model`的json => model实践，利于flutter静态检查
- d. 基于官方文档的全局事件总线`eventBus`实践
- e. flutter各种组件的demo实践，如手势、动画、路由、图片、PageView、canvas、webview等
- f. flutter响应式原理、`setState`更新机制、`InheritedWidget`更新机制研究，并针对`状态持久化`编写示例demo（如首页）
- g. flutter打包发布相关实践，如首屏图、app图标、Android - Gradle 相关配置解读等。