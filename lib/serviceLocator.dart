import 'package:get_it/get_it.dart';
import 'package:the_broadcaster/database/local_database.dart';
import 'package:the_broadcaster/helpers/broadcast_page_helper.dart';
import 'package:the_broadcaster/helpers/global_file_instances.dart';
import 'package:the_broadcaster/helpers/parser_helper.dart';

final serviceLocator = GetIt.instance; // GetIt.I is also valid

void setUp() {
  serviceLocator
      .registerSingleton<GlobalFileHelper>( GlobalFileHelper());

  serviceLocator.registerSingleton<LocalDatabase>(LocalDatabase());

  serviceLocator.registerSingleton<ParserProperties>(ParserProperties());



}
