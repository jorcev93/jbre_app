import 'package:jbre_app/features/plants/domain/domain.dart';

class PlantsRepositoryImpl extends PlantsRepository {
  final PlantsDatasource datasource;

  PlantsRepositoryImpl({required this.datasource});

  @override
  Future<Plant> createUpdatePlant(Map<String, dynamic> plantLike) {
    return datasource.createUpdatePlant(plantLike);
  }

  @override
  Future<Plant> getPlantById(String id) {
    return datasource.getPlantById(id);
  }

  @override
  Future<List<Plant>> getPlantsByPage({int limit = 10, int offset = 0}) {
    return datasource.getPlantsByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Plant>> searchPlantsByTerm(String term) {
    return datasource.searchPlantsByTerm(term);
  }
}
