import '../entities/plants.dart';

abstract class PlantsDatasource {
  Future<List<Plant>> getPlantsByPage({int limit = 10, int offset = 0});
  Future<Plant> getPlantById(String id);
  Future<List<Plant>> searchPlantsByTerm(String term);
  Future<Plant> createUpdatePlant(Map<String, dynamic> plantLike);
}
