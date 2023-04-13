import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_broadcaster/database/local_database.dart';
import 'package:the_broadcaster/helpers/add_parser_helper.dart';
import 'package:the_broadcaster/helpers/parser_file_helper.dart';
import 'package:the_broadcaster/helpers/parser_helper.dart';
import 'package:the_broadcaster/widgets/reusables/application_button.dart';
import 'package:the_broadcaster/widgets/select_contacts_page.dart';
import 'package:the_broadcaster/widgets/text_widgets.dart';

import '../default_colors.dart';
import '../helpers/global_file_instances.dart';
import '../helpers/select_file_helper.dart';
import '../serviceLocator.dart';
import 'add_parser_page.dart';

class ParserFilePage extends StatefulWidget {
  const ParserFilePage(this.helper, {super.key});

  final ParserFileHelper helper;

  @override
  State<ParserFilePage> createState() => _ParserFilePageState();
}

class _ParserFilePageState extends State<ParserFilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SecondaryHeadline('Parser Properties'),
      ),
      body: Column(
        children: [
          
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
  List<ParserFileHelper> files = [];

  @override
  void initState() {
    _fileHelper = FileHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: serviceLocator.get<GlobalFileHelper>(). loader,
      builder: (context, val, child) {
        return AbsorbPointer(
          absorbing: val,
          child: Scaffold(
              appBar: AppBar(
                title: const SecondaryHeadline('Parser File'),
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: ApplicationColorsDark.secondaryColor,
                child: Icon(
                  CupertinoIcons.add,
                  color: ApplicationColorsDark.applicationBlue,
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddParserFilePage()));
                },
              ),
              body: Stack(
                children: [
                  FutureBuilder(
                    future: serviceLocator.get<LocalDatabase>().fetchParsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        snapshot.data as List<ParserFileHelper>;
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
                                  title: Subtitle(file.fileName),
                                  trailing: IconButton(
                                      onPressed: () {
                                        try {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddParserFilePage(parserFileHelper: file,)));
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

class Fillers extends StatelessWidget {
  const Fillers(this._helper, {super.key});

  final AddParserHelper _helper;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: "Add Key",
          onPressed: _helper.newFieldAdded,
          icon: Icon(
            CupertinoIcons.add,
            color: ApplicationColorsDark.applicationBlue,
          ),
        ),
        Flexible(
            child: ApplicationTextField(
          controller: _helper.newFieldController,
          placeholder: "Add new field",
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r"\s")),
            FilteringTextInputFormatter.allow(RegExp(r'^[A-Za-z0-9_.]+$')),
          ],
        )),
        const SizedBox(
          width: 10,
        ),
        Flexible(
            child: ApplicationTextField(
          controller: _helper.newFieldValueController,
          placeholder: "Add new Value",
        ))
      ],
    );
  }
}

class FieldValueWidget extends StatelessWidget {
  const FieldValueWidget(this.field, this.value,
      {super.key, required this.helper});

  final String field;
  final String value;
  final AddParserHelper helper;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              color: ApplicationColorsDark.secondaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Subtitle(
                      field,
                    ),
                    const Subtitle("  :  "),
                    Label(value),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: "Remove Key",
            onPressed: () {
              helper.removeKey(field);
            },
            icon: Icon(
              CupertinoIcons.minus_circle,
              color: ApplicationColorsDark.applicationBlue,
            ),
          ),
        ],
      ),
    );
  }
}

extension FileEx on File {
  String get name => path.split(Platform.pathSeparator).last;
}
