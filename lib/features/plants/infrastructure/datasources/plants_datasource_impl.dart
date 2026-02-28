import 'package:jbre_app/features/plants/domain/domain.dart';
import 'package:jbre_app/config/config.dart';
import 'package:jbre_app/features/plants/infrastructure/mappers/plant_mapper.dart';

class PlantsDatasourceImpl extends PlantsDatasource {
  final HttpAdapter httpAdapter;
  final String accessToken;

  PlantsDatasourceImpl({required this.accessToken})
    : httpAdapter = DioHttpAdapter(
        baseUrl: Environment.apiUrl,
        defaultHeaders: {'Authorization': 'Bearer $accessToken'},
      );

  @override
  Future<Plant> createUpdatePlant(Map<String, dynamic> plantLike) async {
    // TODO: implement createUpdatePlant
    throw UnimplementedError();
  }

  @override
  Future<Plant> getPlantById(String id) async {
    // TODO: implement getPlantById
    throw UnimplementedError();
  }

  @override
  Future<List<Plant>> getPlantsByPage({int limit = 10, int offset = 0}) async {
    try {
      final response = await httpAdapter.get(
        '/plantas',
        queryParameters: {'limit': limit, 'offset': offset},
      );

      final List<Plant> plants = [];
      for (final plant in response.data ?? []) {
        plants.add(PlantMapper.plantJsonToEntity(plant));
      }
      return plants;
    } catch (e) {
      throw Exception('Error getting plants: $e');
    }
  }

  @override
  Future<List<Plant>> searchPlantsByTerm(String term) async {
    // TODO: implement searchPlantsByTerm
    throw UnimplementedError();
  }
}
