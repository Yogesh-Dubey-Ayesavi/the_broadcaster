import 'package:flutter/material.dart';
import 'package:the_broadcaster/default_colors.dart';
import 'package:the_broadcaster/helpers/global_file_instances.dart';
import 'package:the_broadcaster/inherited_widget.dart';
import 'package:the_broadcaster/serviceLocator.dart';
import 'package:the_broadcaster/widgets/add_files_page.dart';
import 'package:the_broadcaster/widgets/broadcast_page.dart';
import 'package:the_broadcaster/widgets/the_broadCast_page.dart';
import 'package:the_broadcaster/widgets/parser_properties.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUp();
  Future.delayed(const Duration(seconds: 1), () {
    serviceLocator.get<GlobalFileHelper>();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return InheritedInstance(
      child: MaterialApp(
        title: 'Broadcaster Application to broadcast multiple messages vs SMS',
        theme: ThemeData(
            scaffoldBackgroundColor: ApplicationColorsDark.primaryColor,
            primaryColor: ApplicationColorsDark.primaryColor,
            appBarTheme: AppBarTheme(
                backgroundColor: ApplicationColorsDark.secondaryColor)),
        initialRoute: '/',
        routes: {
          "/": (context) => const MainPage(),
          "/broadcast_page": (context) => const BroadCastPage(),
          "/parser_page": (context) => const ParserPage(),
          '/add_files': (context) => const AddFilePage(),
        },
      ),
    );
  }
}
