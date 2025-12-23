import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goals_app_localdata/main_layout/clubit/main_states.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(MainInitialState());

  static MainCubit get(context) => BlocProvider.of<MainCubit>(context);

  final addTextController = TextEditingController();
  final statusTextController = TextEditingController();

  Database? database;
  List<Map> goals_list = [];

  Future<void> initSQL() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'goals.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''CREATE TABLE Goals (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            status TEXT
          )'''
        );
      },
    );
    print('✅ Database initialized');
  }

  Future<void> getData() async {
    emit(GetDataLoadingState());
    if (database == null) {
      await initSQL();
    }
    try {
      goals_list = await database!.rawQuery('SELECT * FROM Goals');
      print('📊 Fetched ${goals_list.length} goals: $goals_list');
      emit(GetDataSuccessState());
    } catch (onError) {
      print('❌ Error getting data: $onError');
      emit(GetDataErrorState());
    }
  }

  Future<void> insertData(String name, String status) async {
    print('➕ Inserting: name="$name", status="$status"');
    emit(InsertDataLoadingState());
    
    if (database == null) {
      await initSQL();
    }
    
    try {
      await database!.transaction((txn) async {
        await txn.rawInsert(
          'INSERT INTO Goals(name, status) VALUES(?, ?)',
          [name, status],
        );
      });
      
      print('✅ Insert successful, now fetching updated data...');
      
      // Refresh the list from database
      goals_list = await database!.rawQuery('SELECT * FROM Goals');
      print('📊 After insert: ${goals_list.length} goals');
      
      emit(InsertDataSuccessState());
      
      // Emit GetDataSuccessState to trigger UI rebuild
      emit(GetDataSuccessState());
      
    } catch (onError) {
      print('❌ Error inserting data: $onError');
      emit(InsertDataErrorState());
    }
  }

  @override
  Future<void> close() async {
    addTextController.dispose();
    statusTextController.dispose();
    await database?.close();
    return super.close();
  }
}