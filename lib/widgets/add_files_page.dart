import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_broadcaster/helpers/global_file_instances.dart';
import 'package:the_broadcaster/helpers/select_file_helper.dart';
import 'package:the_broadcaster/widgets/text_widgets.dart';

import '../default_colors.dart';
import '../serviceLocator.dart';

class AddFilePage extends StatefulWidget {
  const AddFilePage({super.key});
  @override
  State<AddFilePage> createState() => _AddFilePageState();
}

class _AddFilePageState extends State<AddFilePage> {
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
      valueListenable: serviceLocator.get<GlobalFileHelper>().loader,
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
                  if (await _fileHelper.pickFile(context)) {
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
                                    trailing: PopupMenuButton(
                                        icon: Icon(
                                          Icons.menu_open_rounded,
                                          color: ApplicationColorsDark
                                              .applicationBlue,
                                        ),
                                        color: const Color(0xff191919),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                        ),
                                        onSelected: (value) => {
                                              if (value == 0)
                                                {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        backgroundColor:
                                                            ApplicationColorsDark
                                                                .secondaryColor,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                20.0),
                                                          ),
                                                        ),
                                                        title: Label(
                                                          'Would you like to delete file ${file?.name}',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            child:
                                                                const Subtitle(
                                                                    "Yes"),
                                                            onPressed:
                                                                () async {
                                                              if (file !=
                                                                  null) {
                                                                serviceLocator
                                                                    .get<
                                                                        GlobalFileHelper>()
                                                                    .removeFile(
                                                                        file)
                                                                    .then(
                                                                        (value) {
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(
                                                                      () {});
                                                                });
                                                              }
                                                            },
                                                          ),
                                                          TextButton(
                                                            child:
                                                                const Subtitle(
                                                                    "No"),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  )
                                                }
                                            },
                                        itemBuilder: (context) => [
                                              PopupMenuItem<int>(
                                                value: 0,
                                                child: Subtitle(
                                                  'Delete File',
                                                  color: ApplicationColorsDark
                                                      .titleColor,
                                                ),
                                              ),
                                            ])),
                              );
                            },
                          );
                        }
                        return const Center(
                            child: Subtitle('No files to display'));
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  if (val == true) ...[
                    const CircularProgressIndicator(),
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
