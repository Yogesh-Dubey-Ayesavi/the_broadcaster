import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_broadcaster/database/local_database.dart';
import 'package:the_broadcaster/default_colors.dart';
import 'package:the_broadcaster/serviceLocator.dart';
import 'package:the_broadcaster/utils.dart';
import 'package:the_broadcaster/widgets/add_files_page.dart';
import 'package:the_broadcaster/widgets/parser_properties.dart';
import 'package:the_broadcaster/widgets/reusables/previous_broadcast_tile.dart';
import 'package:the_broadcaster/widgets/text_widgets.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    rebuiltNeededStream.stream.listen((event) {
      if (event == 'MainPage') {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: ApplicationColorsDark.secondaryColor,
        width: MediaQuery.of(context).size.width / 1.5,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ListTile(
                leading: Icon(
                  CupertinoIcons.doc,
                  color: ApplicationColorsDark.applicationBlue,
                ),
                title: const Subtitle("Files"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddFilePage()));
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.code,
                color: ApplicationColorsDark.applicationBlue,
              ),
              title: const Subtitle("Parser"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ParserPage()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const SecondaryHeadline('Home'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ApplicationColorsDark.secondaryColor,
        child: Icon(
          CupertinoIcons.add_circled,
          color: ApplicationColorsDark.applicationBlue,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/broadcast_page');
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: serviceLocator.get<LocalDatabase>().broadCasts,
            builder: (context, value, child) {
              if (value.isNotEmpty) {
                return Flexible(
                  child: ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return PreviousBroadcastCard(value[index]);
                    },
                  ),
                );
              } else if (value.isEmpty) {
                return const Center(
                  child: Subtitle("No Broadcasts Yet"),
                );
              }
              return const CupertinoActivityIndicator();
            },
          )
        ],
      ),
    );
  }
}
