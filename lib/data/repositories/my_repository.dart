import 'package:dio_example/data/models/top_level_data.dart';
import 'package:dio_example/data/services/open_api_provider/open_api_provider.dart';

class MyRepository {
  MyRepository({required this.openApiProvider});

  final OpenApiProvider openApiProvider;

  Future<TopLevelData> fetchMemesData() => openApiProvider.fetchMemesData();
}
