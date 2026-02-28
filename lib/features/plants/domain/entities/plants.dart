class Plant {
  final String id;
  final bool estado;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Propiedades Directas
  final String nombreCientifico;
  final String? nombreComun;
  final String? sinonimos;
  final String? descripcion;
  final String? usos;
  final String? seccionId;

  // Entidades Relacionadas (Opcionales por el consumo API)
  final PlantSection? seccion;
  final Taxonomy? taxonomia;
  final GeneralData? datosGenerales;
  final CultivationCondition? condicionCultivo;
  final Morphology? morfologia;
  final List<EntryRecord>? registrosIngreso;
  // Fotos list can be empty instead of null, keeping it simple
  // final List<dynamic>? fotos;

  Plant({
    required this.id,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
    required this.nombreCientifico,
    this.nombreComun,
    this.sinonimos,
    this.descripcion,
    this.usos,
    this.seccionId,
    this.seccion,
    this.taxonomia,
    this.datosGenerales,
    this.condicionCultivo,
    this.morfologia,
    this.registrosIngreso,
  });
}

class PlantSection {
  final String id;
  final String nombre;
  final String? descripcion;

  PlantSection({required this.id, required this.nombre, this.descripcion});
}

class Taxonomy {
  final String id;
  final String? reino;
  final String? phylum;
  final String? division;
  final String? clase;
  final String? subclase;
  final String? orden;
  final String? familia;
  final String? subfamilia;
  final String? tribu;
  final String? subtribu;
  final String? genero;
  final String? especie;
  final String? subespecie;
  final String? variedad;
  final String? cultivar;
  final String? autor;

  Taxonomy({
    required this.id,
    this.reino,
    this.phylum,
    this.division,
    this.clase,
    this.subclase,
    this.orden,
    this.familia,
    this.subfamilia,
    this.tribu,
    this.subtribu,
    this.genero,
    this.especie,
    this.subespecie,
    this.variedad,
    this.cultivar,
    this.autor,
  });
}

class GeneralData {
  final String id;
  final String? endemismo;
  final String? estadoConservacion;
  final String? fuenteInformacion;
  final String? habitoCrecimiento;
  final String? historialRecibido;
  final String? materialRecibido;
  final int? numeroIndividuos;
  final String? procedencia;
  final String? comoSeReconoce;
  final String? ubicacionGeografica;
  final String? zonaVida;

  GeneralData({
    required this.id,
    this.endemismo,
    this.estadoConservacion,
    this.fuenteInformacion,
    this.habitoCrecimiento,
    this.historialRecibido,
    this.materialRecibido,
    this.numeroIndividuos,
    this.procedencia,
    this.comoSeReconoce,
    this.ubicacionGeografica,
    this.zonaVida,
  });
}

class CultivationCondition {
  final String id;
  final String? exposicion;
  final String? floracion;
  final String? humedad;
  final String? riego;
  final String? laboresCulturales;
  final String? observaciones;

  CultivationCondition({
    required this.id,
    this.exposicion,
    this.floracion,
    this.humedad,
    this.riego,
    this.laboresCulturales,
    this.observaciones,
  });
}

class Morphology {
  final String id;
  // Las partes de la morfología son referencias a otras entidades en la base de datos,
  // aquí pueden declararse de forma genérica o detallada.
  // final dynamic hojas;
  // final dynamic tallo;
  // final dynamic raiz;
  // final dynamic flor;
  // final dynamic inflorescencia;
  // final dynamic fruto;

  Morphology({required this.id});
}

class EntryRecord {
  final String id;
  final String? personaId;
  final String plantaId;
  final int cantidad;
  final DateTime fechaIngreso;
  final String? observaciones;
  final Person? persona;
  final DateTime createdAt;
  final DateTime updatedAt;

  EntryRecord({
    required this.id,
    this.personaId,
    required this.plantaId,
    required this.cantidad,
    required this.fechaIngreso,
    this.observaciones,
    this.persona,
    required this.createdAt,
    required this.updatedAt,
  });
}

class Person {
  final String id;
  final bool estado;
  final String nombre;
  final String apellido;
  final String? genero;
  final DateTime? fechaNacimiento;
  final bool esAutor;
  final bool esColector;
  final String? rolId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Person({
    required this.id,
    required this.estado,
    required this.nombre,
    required this.apellido,
    this.genero,
    this.fechaNacimiento,
    required this.esAutor,
    required this.esColector,
    this.rolId,
    required this.createdAt,
    required this.updatedAt,
  });
}
