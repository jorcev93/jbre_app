# JBRE Backend Context & Architecture

Este documento resume la arquitectura, tecnologías y modelos de datos principales del backend (`jbre-back`) para facilitar la comunicación con el frontend (`jbre_app`) en el futuro. 

## Tecnologías Principales
- **Framework:** NestJS (Node.js/TypeScript)
- **Base de Datos:** Relacionada mediante TypeORM (observado a través de uso de entities). Normalmente esto se asocia con bases de datos como PostgreSQL o MySQL.
- **Autenticación:** JWT (JSON Web Tokens) reflejado en un `auth.module` con estrategias y `guards`.
- **Arquitectura de Software:** Modular clásica de NestJS (`controller -> service -> entity/dto`), muy similar a la estructura de *Clean Architecture* que se usaría del lado de Flutter.
- **Infraestructura:** Usa un archivo `.env` y `docker-compose` para orquestar la DB localmente.

## Estructura del Proyecto
El backend está organizado dentro de la carpeta (o módulo) `modules/`, donde cada recurso/entidad cuenta con:
- `controllers` (Manejan peticiones HTTP y declaran endpoints)
- `services` (Contienen la lógica de negocio y comunicación con la base de datos)
- `entities` (Definen las tablas/documentos y sus relaciones directas)
- `dto` (Definen cómo los datos deben enviarse para crear y actualizar entidades)

## Modelo de Datos Principal: Planta (`Planta`)

El dominio de `Planta` es extenso y funciona como un contenedor agregado. Está normalizado, lo cual divide una gran cantidad de atributos en tablas/entidades secundarias.

### 1. Entidad Base
Todas las tablas extienden de un `BaseEntity` que garantiza al menos los siguientes campos:
- `id` (string / uuid)
- `estado` (boolean) -> Típicamente usado para un "borrado lógico" (soft delete) o estados activo/inactivo.
- `createdAt` (Date) -> Fecha de registro.
- `updatedAt` (Date) -> Fecha de última modificación.

### 2. Atributos Directos de la Planta
- `nombreCientifico` (string)
- `nombreComun` (string, opcional)
- `sinonimos` (string, opcional)
- `descripcion` (string, opcional)
- `usos` (string, opcional)
- `seccionId` (string, opcional) -> Llave foránea hacia la sección.

### 3. Relaciones Anidadas Clave
El modelo `Planta` tiene relación con múltiples modelos, lo que significa que el JSON devuelto desde la API podría contener estas llaves anidadas:

- **`seccion`** (Sección): Clasifica el lugar o área relacionada a esta planta.
- **`morfologia`** (Morfología): Relación con las características físicas como hojas, tallo, raíz, flor, inflorescencia y fruto. 
- **`taxonomia`** (Taxonomía): Toda la categorización biológica de la planta (reino, género, subclase, orden, clase, familia, especie, etc.).
- **`condicionCultivo`** (Condición de Cultivo): Detalles para su mantenimiento como exposición al sol, humedad, riego, floración y observaciones.
- **`datosGenerales`** (Datos Generales): Datos biográficos del espécimen, historia de origen, procedencia, endemismo y estado de conservación.
- **`fotos`** (Fotos[]): Un listado de entidades fotográficas relacionadas.
- **`registrosIngreso`** (RegistroIngreso[]): Historial sobre su ingreso al repositorio botánico.

> [!NOTE] Notas para Integración con Flutter
> 1. Los DTOs de creación (`CreatePlantaDto`) *solo* piden campos base directos, lo que significa que la inserción de las relaciones grandes probablemente se hace enviando objetos anidados o a través de endpoints distintos (p. ej. un endpoint para guardar solo la Morfología que requiere el `plantaId`).
> 2. En `Dart`, deberías modelar todos los sub-modelos de forma independiente para permitir el fácil casteo (`fromJson`), debido a que en algunas peticiones GET pueden venir nulos si la consulta no incluye los `relations` de TypeORM en el Back.
