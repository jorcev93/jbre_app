import 'package:jbre_app/features/plants/domain/entities/plants.dart';

class PlantMapper {
  static Plant plantJsonToEntity(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] ?? '',
      estado: json['estado'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      nombreCientifico: json['nombreCientifico'] ?? '',
      nombreComun: json['nombreComun'],
      sinonimos: json['sinonimos'],
      descripcion: json['descripcion'],
      usos: json['usos'],
      seccionId: json['seccionId'],
      seccion: json['seccion'] != null
          ? plantSectionJsonToEntity(json['seccion'])
          : null,
      taxonomia: json['taxonomia'] != null
          ? taxonomyJsonToEntity(json['taxonomia'])
          : null,
      datosGenerales: json['datosGenerales'] != null
          ? generalDataJsonToEntity(json['datosGenerales'])
          : null,
      condicionCultivo: json['condicionCultivo'] != null
          ? cultivationConditionJsonToEntity(json['condicionCultivo'])
          : null,
      morfologia: json['morfologia'] != null
          ? morphologyJsonToEntity(json['morfologia'])
          : null,
      registrosIngreso: _parseEntryRecords(json['registrosIngreso']),
    );
  }

  static PlantSection plantSectionJsonToEntity(Map<String, dynamic> json) {
    return PlantSection(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
    );
  }

  static Taxonomy taxonomyJsonToEntity(Map<String, dynamic> json) {
    return Taxonomy(
      id: json['id'] ?? '',
      reino: json['reino'],
      phylum: json['phylum'],
      division: json['division'],
      clase: json['clase'],
      subclase: json['subclase'],
      orden: json['orden'],
      familia: json['familia'],
      subfamilia: json['subfamilia'],
      tribu: json['tribu'],
      subtribu: json['subtribu'],
      genero: json['genero'],
      especie: json['especie'],
      subespecie: json['subespecie'],
      variedad: json['variedad'],
      cultivar: json['cultivar'],
      autor: json['autor'],
    );
  }

  static GeneralData generalDataJsonToEntity(Map<String, dynamic> json) {
    return GeneralData(
      id: json['id'] ?? '',
      endemismo: json['endemismo'],
      estadoConservacion: json['estadoConservacion'],
      fuenteInformacion: json['fuenteInformacion'],
      habitoCrecimiento: json['habitoCrecimiento'],
      historialRecibido: json['historialRecibido'],
      materialRecibido: json['materialRecibido'],
      numeroIndividuos: json['numeroIndividuos'],
      procedencia: json['procedencia'],
      comoSeReconoce: json['comoSeReconoce'],
      ubicacionGeografica: json['ubicacionGeografica'],
      zonaVida: json['zonaVida'],
    );
  }

  static CultivationCondition cultivationConditionJsonToEntity(
    Map<String, dynamic> json,
  ) {
    return CultivationCondition(
      id: json['id'] ?? '',
      exposicion: json['exposicion'],
      floracion: json['floracion'],
      humedad: json['humedad'],
      riego: json['riego'],
      laboresCulturales: json['laboresCulturales'],
      observaciones: json['observaciones'],
    );
  }

  static Morphology morphologyJsonToEntity(Map<String, dynamic> json) {
    return Morphology(id: json['id'] ?? '');
  }

  static List<EntryRecord>? _parseEntryRecords(dynamic entriesJson) {
    if (entriesJson == null || entriesJson is! List) return null;
    return entriesJson
        .map((json) => entryRecordJsonToEntity(json as Map<String, dynamic>))
        .toList();
  }

  static EntryRecord entryRecordJsonToEntity(Map<String, dynamic> json) {
    return EntryRecord(
      id: json['id'] ?? '',
      personaId: json['personaId'],
      plantaId: json['plantaId'] ?? '',
      cantidad: json['cantidad'] ?? 0,
      fechaIngreso:
          DateTime.tryParse(json['fechaIngreso'] ?? '') ?? DateTime.now(),
      observaciones: json['observaciones'],
      persona: json['persona'] != null
          ? personJsonToEntity(json['persona'])
          : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  static Person personJsonToEntity(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ?? '',
      estado: json['estado'] ?? false,
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      genero: json['genero'],
      fechaNacimiento: json['fechaNacimiento'] != null
          ? DateTime.tryParse(json['fechaNacimiento'])
          : null,
      esAutor: json['esAutor'] ?? false,
      esColector: json['esColector'] ?? false,
      rolId: json['rolId'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
