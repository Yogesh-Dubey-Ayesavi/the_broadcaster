import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_broadcaster/helpers/global_file_instances.dart';
import 'package:the_broadcaster/revision/revision_helpers.dart/broadcast_helper.dart';
import 'package:the_broadcaster/serviceLocator.dart';
import 'package:the_broadcaster/utils.dart';
import 'package:the_broadcaster/widgets/more_info_profile.dart';
import 'package:the_broadcaster/widgets/reusables/application_button.dart';
import 'package:the_broadcaster/widgets/reusables/contact_tile.dart';
import 'package:the_broadcaster/widgets/reusables/file_tile.dart';
import 'package:the_broadcaster/widgets/text_widgets.dart';

import '../default_colors.dart';
import '../helpers/contacts_helper.dart';
import '../models/contact.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage(this.contacts, {super.key, required this.fileName});
  final String fileName;
  final List<Contact> contacts;

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final SelectContactHelper _helper = SelectContactHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SecondaryHeadline('${widget.fileName} Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ApplicationTextField(
                placeholder: 'Search Contact',
                onChanged: (value) {},
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              PopupMenuButton(
                icon: Icon(
                  Icons.filter_list,
                  color: ApplicationColorsDark.applicationBlue,
                ),
                color: const Color(0xff191919),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                onSelected: (value) {
                  if (value == 0) {
                    _helper.selectFirst100(widget.contacts);
                  }
                  // else if (value == 1) {
                  //   _helper.selectLast100(widget.contacts);
                  // }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Subtitle(
                      'Toggle First 100',
                      color: ApplicationColorsDark.titleColor,
                    ),
                  ),
                  // PopupMenuItem<int>(
                  //     value: 1,
                  //     child: Subtitle(
                  //       'Toggle Last 100',
                  //       color: ApplicationColorsDark.titleColor,
                  //     )),
                ],
              )
            ]),
            Flexible(
              child: ListView.builder(
                itemCount: widget.contacts.length,
                controller: _helper.scrollController,
                itemBuilder: (context, index) {
                  Contact contact = widget.contacts[index];
                  return Card(
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    margin: EdgeInsets.zero,
                    color: ApplicationColorsDark.tileColor,
                    child: ListTile(
                      leading: ValueListenableBuilder(
                        valueListenable: contact.isSelected,
                        builder: (context, value, child) {
                          return Checkbox(
                              value: value,
                              onChanged: (val) {
                                if (val != null) {
                                  contact.toggleIsSelected(val);
                                  rebuiltNeededStream.add('BroadCastPage');
                                  rebuiltNeededStream
                                      .add('RevisionBroadCastPage');
                                }
                              });
                        },
                      ),
                      title: Label(contact.name ?? "Not Provided"),
                      subtitle: Subtitle(contact.phoneNumber),
                      trailing: IconButton(
                          onPressed: () {
                            try {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileWidget(contact)));
                            } catch (e) {
                              print(e);
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
            )
          ],
        ),
      ),
    );
  }
}
