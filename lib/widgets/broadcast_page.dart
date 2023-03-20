import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_broadcaster/helpers/broadcast_page_helper.dart';
import 'package:the_broadcaster/helpers/global_file_instances.dart';
import 'package:the_broadcaster/inherited_widget.dart';
import 'package:the_broadcaster/serviceLocator.dart';
import 'package:the_broadcaster/widgets/reusables/application_button.dart';
import 'package:the_broadcaster/widgets/select_contacts_page.dart';
import 'package:the_broadcaster/widgets/select_file_page.dart';
import 'package:the_broadcaster/widgets/text_widgets.dart';
import '../default_colors.dart';
import '../utils.dart';

class BroadCastPage extends StatefulWidget {
  const BroadCastPage({
    super.key,
  });

  @override
  State<BroadCastPage> createState() => _BroadCastPageState();
}

class _BroadCastPageState extends State<BroadCastPage> {
  late BroadCastHelper _helper;

  @override
  void initState() {
    _helper = BroadCastHelper();
    rebuiltNeededStream.stream.listen((event) {
      if (event == 'BroadCastPage') {
        // setState(() {});
        _helper.updateMap();
        // print("setState((){})");
      }
    });
    // print("init from broadcast helper");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cleanUp() async {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const SecondaryHeadline('BroadCast Page'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ApplicationColorsDark.secondaryColor,
        child: Icon(
          Icons.send,
          color: ApplicationColorsDark.applicationBlue,
        ),
        onPressed: () async {
          if (await _helper.sendMessage(context)) {
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pop(context);
            });
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              child: Caption(
                "Message",
                color: ApplicationColorsDark.applicationBlue,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ApplicationTextField(
                  placeholder: 'Type a Message to broadcast',
                  maxLength: 1000,
                  controller: _helper.textEditingController,
                  captitalization: TextCapitalization.sentences,
                  keyboardtype: TextInputType.multiline,
                  action: TextInputAction.newline),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              child: Caption(
                "Recipients",
                color: ApplicationColorsDark.applicationBlue,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _helper.selectedContactsFileMap,
              builder: (context, value, child) {
                List<String> keys = value.keys.toList();
                if (keys.isNotEmpty) {
                  return Flexible(
                    child: ListView.builder(
                      itemCount: keys.length,
                      itemBuilder: (context, index) {
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
                                          value[keys[index]] ?? [],
                                          fileName: keys[index])));
                            },
                            leading: Icon(
                              CupertinoIcons.doc,
                              color: ApplicationColorsDark.applicationBlue,
                            ),
                            title: Label(keys[index]),
                            subtitle: Subtitle(
                                " ${value[keys[index]]?.length.toString()} contacts selected"),
                            trailing: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ContactsPage(
                                              value[keys[index]] ?? [],
                                              fileName: keys[index])));
                                },
                                icon: Icon(
                                  CupertinoIcons.chevron_right_circle,
                                  color: ApplicationColorsDark.applicationBlue,
                                )),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            ApplicationFilledButton(
              buttonlabel: 'Select Contacts',
              active: true,
              ontap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FilePage(contactsMap: _helper.fileMap)));
              },
            )
          ],
        ),
      ),
    );
  }
}
