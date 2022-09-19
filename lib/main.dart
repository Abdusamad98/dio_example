import 'package:dio_example/data/local/storage.dart';
import 'package:dio_example/data/repositories/my_repository.dart';
import 'package:dio_example/data/services/open_api_provider/open_api_client.dart';
import 'package:dio_example/data/services/open_api_provider/open_api_provider.dart';
import 'package:dio_example/presentation/my_home_page.dart';
import 'package:dio_example/view_models/my_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageRepository.getInstance();

  OpenApiProvider openApiProvider =
      OpenApiProvider(openApiClient: OpenApiClient());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => MyViewModel(
          myRepository: MyRepository(openApiProvider: openApiProvider),
        ),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}
