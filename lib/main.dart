import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // ProviderScopeでラップする
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FutureProvider',
      theme: ThemeData(
        textTheme: const TextTheme(bodyText2: TextStyle(fontSize: 50)),
      ),
      home: HomePage(),
    );
  }
}

// FutureProviderの作成 (単一のデータを非同期で取得する)
final futureProvider = FutureProvider<dynamic>((ref) async {
  await Future.delayed(const Duration(seconds: 3));
  return 'Hello World';
});

// FutureProviderを作成すると「AsyncValue」オブジェクトを生成できる
//「AsyncValue」は非同期通信の通信中、通信終了、異常終了処理をハンドリングしてくれるRiverpodの便利な機能のこと

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AsyncValueオブジェクトを取得する
    final asyncValue = ref.watch(futureProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Hallo World')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          // 状態を更新する
          ref.refresh(futureProvider);
        },
      ),
      body: Center(
        child: asyncValue.when(
          error: (err, _) => Text(err.toString()), //エラー時
          loading: () => const CircularProgressIndicator(), //読み込み時
          data: (data) => Text(data.toString()), //データ受け取り時
        ),
      ),
    );
  }
}
