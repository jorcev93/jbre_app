import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jbre_app/features/plants/domain/domain.dart';
import 'package:jbre_app/features/plants/presentation/providers/plants_repository_provider.dart';

final plantsProvider = NotifierProvider<PlantsNotifier, PlantsState>(
  PlantsNotifier.new,
);

//! 2. Creamos el Notifier provider
class PlantsNotifier extends Notifier<PlantsState> {
  late final PlantsRepository plantsRepository;

  @override
  PlantsState build() {
    plantsRepository = ref.watch(plantsRepositoryProvider);

    // Invocamos la primera carga de datos (es async)
    Future.microtask(() => loadNextPage());

    return PlantsState();
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final plants = await plantsRepository.getPlantsByPage(
      limit: state.limit,
      offset: state.offset,
    );

    if (plants.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      plants: [...state.plants, ...plants],
    );
  }
}

//! 1. Creamos el state

class PlantsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Plant> plants;

  PlantsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.plants = const [],
  });

  PlantsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Plant>? plants,
  }) => PlantsState(
    isLastPage: isLastPage ?? this.isLastPage,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
    isLoading: isLoading ?? this.isLoading,
    plants: plants ?? this.plants,
  );
}
