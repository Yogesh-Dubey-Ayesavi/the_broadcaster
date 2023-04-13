import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_broadcaster/helpers/select_file_helper.dart';
import 'package:the_broadcaster/revision/revision_helpers.dart/broadcast_helper.dart';
import 'package:the_broadcaster/widgets/reusables/file_tile.dart';
import 'package:the_broadcaster/widgets/select_contacts_page.dart';
import 'package:the_broadcaster/widgets/text_widgets.dart';

import '../default_colors.dart';
import '../helpers/global_file_instances.dart';
import '../models/broadcast.dart';
import '../models/contact.dart';
import '../serviceLocator.dart';

class FilePage extends StatefulWidget {
  const FilePage({super.key, required this.contactsMap});

  final Map<String, List<Contact>> contactsMap;

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  late final FileHelper _fileHelper;
  List<String> files = [];

  @override
  void initState() {
    _fileHelper = FileHelper();
    files = widget.contactsMap.keys.toList();
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
                title: const SecondaryHeadline('Files'),
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
                  ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final keys = widget.contactsMap.keys.toList();
                      return Card(
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        margin: EdgeInsets.zero,
                        color: ApplicationColorsDark.tileColor,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactsPage(
                                        widget.contactsMap[keys[index]] ?? [],
                                        fileName: keys[index])));
                          },
                          leading: Icon(
                            CupertinoIcons.doc,
                            color: ApplicationColorsDark.applicationBlue,
                          ),
                          title: Subtitle(files[index]),
                          trailing: IconButton(
                              onPressed: () {
                                try {
                                  // print(' ${widget.contactsMap[keys[index]]}');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ContactsPage(
                                              widget.contactsMap[keys[index]] ??
                                                  [],
                                              fileName: keys[index])));
                                } catch (e) {
                                  // print(e);
                                }
                              },
                              icon: Icon(
                                CupertinoIcons.chevron_right_circle,
                                color: ApplicationColorsDark.applicationBlue,
                              )),
                        ),
                      );
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
