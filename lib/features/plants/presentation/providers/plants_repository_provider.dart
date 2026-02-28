import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jbre_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:jbre_app/features/plants/domain/repositories/plants_repository.dart';
import 'package:jbre_app/features/plants/infrastructure/datasources/plants_datasource_impl.dart';
import 'package:jbre_app/features/plants/infrastructure/repositories/plants_repository_impl.dart';

final plantsRepositoryProvider = Provider<PlantsRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final plantsRepository = PlantsRepositoryImpl(
    datasource: PlantsDatasourceImpl(accessToken: accessToken),
  );
  return plantsRepository;
});
