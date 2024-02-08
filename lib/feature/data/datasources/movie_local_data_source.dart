// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:movie_app/core/error/exception.dart';
import 'package:movie_app/feature/data/models/movie_model.dart';

import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class MovieLocalDataSource {
  Future<List<MovieModel>> getLastMoviesFromCache();
  Future<void> moviesToCache(List<MovieModel> movies);
  Future<MovieModel?> getMovieFromCacheById(int id);
}

const String CACHED_PERSONS_LIST = 'CACHED_PERSONS_LIST';

class DatabaseProvider {
  static final DatabaseProvider instance = DatabaseProvider._init();
  static Database? _database;

  DatabaseProvider._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('persons.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = join(appDocDir.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE $CACHED_PERSONS_LIST (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  json TEXT NOT NULL
)
''');
  }
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final DatabaseProvider databaseProvider;

  MovieLocalDataSourceImpl({required this.databaseProvider});

  @override
  Future<MovieModel?> getMovieFromCacheById(int id) async {
    final db = await databaseProvider.database;
    final List<Map<String, dynamic>> result = await db.query(
      CACHED_PERSONS_LIST,
      where: "id = ?", // Используйте колонку id для поиска
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      print('Found in cache: ${json.decode(result.first['json'])}');
      return MovieModel.fromJson(json.decode(result.first['json']));
    } else {
      print('Not found in cache: $id');
      return null;
    }
  }

  @override
  Future<List<MovieModel>> getLastMoviesFromCache() async {
    final db = await databaseProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(CACHED_PERSONS_LIST);

    if (maps.isNotEmpty) {
      print(maps.length);
      return maps
          .map((person) => MovieModel.fromJson(json.decode(person['json'])))
          .toList();
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> moviesToCache(List<MovieModel> movies) async {
    final db = await databaseProvider.database;
    Batch batch = db.batch();

    for (var movie in movies) {
      batch.insert(CACHED_PERSONS_LIST,
          {'id': movie.id, 'json': json.encode(movie.toJson())},
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  Future<void> printCachedMovies() async {
    final db = await databaseProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(CACHED_PERSONS_LIST);
    if (maps.isNotEmpty) {
      for (var map in maps) {
        print(json.decode(map['json']));
      }
    } else {
      print("Кеш пуст.");
    }
  }
}
