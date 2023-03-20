import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_broadcaster/widgets/select_contacts_page.dart';
import 'package:the_broadcaster/widgets/text_widgets.dart';

import '../default_colors.dart';
import '../helpers/global_file_instances.dart';
import '../helpers/select_file_helper.dart';
import '../serviceLocator.dart';

class ParserFilePage extends StatefulWidget {
  const ParserFilePage({super.key});

  @override
  State<ParserFilePage> createState() => _ParserFilePageState();
}

class _ParserFilePageState extends State<ParserFilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SecondaryHeadline('Parser Properties'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            child: Caption(
              "Message",
              color: ApplicationColorsDark.applicationBlue,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: ApplicationTextField(
              placeholder: 'Add phone number field in csv file',
              maxLength: 100,
            ),
          ),
        ],
      ),
    );
  }
}

class ParserPage extends StatefulWidget {
  const ParserPage({super.key});
  @override
  State<ParserPage> createState() => _ParserPageState();
}

class _ParserPageState extends State<ParserPage> {
  late final FileHelper _fileHelper;
  List<File?> files = [];

  @override
  void initState() {
    _fileHelper = FileHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _fileHelper.loader,
      builder: (context, val, child) {
        return AbsorbPointer(
          absorbing: val,
          child: Scaffold(
              appBar: AppBar(
                title: const SecondaryHeadline('Add Files'),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: ApplicationColorsDark.secondaryColor,
                child: Icon(
                  CupertinoIcons.add,
                  color: ApplicationColorsDark.applicationBlue,
                ),
                onPressed: () async {
                  if (await _fileHelper.pickFile()) {
                    setState(() {});
                  } else {}
                },
              ),
              body: Stack(
                children: [
                  FutureBuilder(
                    future: _fileHelper.getFiles(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        snapshot.data as List<File?>;
                        files = snapshot.data!;
                        if (files.isNotEmpty) {
                          return ListView.builder(
                            itemCount: files.length,
                            itemBuilder: (context, index) {
                              final file = files[index];
                              return Card(
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                margin: EdgeInsets.zero,
                                color: ApplicationColorsDark.tileColor,
                                child: ListTile(
                                  leading: Icon(
                                    CupertinoIcons.doc,
                                    color:
                                        ApplicationColorsDark.applicationBlue,
                                  ),
                                  title: Subtitle(file?.name),
                                  trailing: IconButton(
                                      onPressed: () {
                                        try {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ParserFilePage()));
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      icon: Icon(
                                        CupertinoIcons.chevron_right_circle,
                                        color: ApplicationColorsDark
                                            .applicationBlue,
                                      )),
                                ),
                              );
                            },
                          );
                        }
                        return const Center(
                            child: Subtitle('No files to display'));
                      }

                      return const Center(child: CupertinoActivityIndicator());
                    },
                  ),
                  if (val == true) ...[
                    const CupertinoActivityIndicator(),
                  ],
                ],
              )),
        );
      },
    );
  }
}

extension FileEx on File {
  String get name => path.split(Platform.pathSeparator).last;
}
