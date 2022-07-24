import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  DatabaseConnection connection = DatabaseConnection.delayed(() async {
    final isolate = await createDriftIsolate();
    return await isolate.connect();
  }());

  Get.put(MyDatabase.connect(connection));

  Get.lazyPut<BookDaoStorage>(() => BookDaoStorage(Get.find<MyDatabase>()));
  Get.lazyPut<SongDaoStorage>(() => SongDaoStorage(Get.find<MyDatabase>()));

  runApp(const MyApp());
}