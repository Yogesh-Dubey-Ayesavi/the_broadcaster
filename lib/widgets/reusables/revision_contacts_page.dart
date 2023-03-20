import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_broadcaster/helpers/global_file_instances.dart';
import 'package:the_broadcaster/revision/revision_helpers.dart/broadcast_helper.dart';
import 'package:the_broadcaster/serviceLocator.dart';
import 'package:the_broadcaster/widgets/reusables/application_button.dart';
import 'package:the_broadcaster/widgets/reusables/contact_tile.dart';
import 'package:the_broadcaster/widgets/reusables/file_tile.dart';
import 'package:the_broadcaster/widgets/text_widgets.dart';

import '../../default_colors.dart';
import '../../helpers/contacts_helper.dart';
import '../../models/contact.dart';

class RevisionContactPage extends StatefulWidget {
  const RevisionContactPage(this.contacts, {super.key, required this.fileName});

  final String fileName;

  final List<Contact> contacts;

  @override
  State<RevisionContactPage> createState() => _RevisionContactPageState();
}

class _RevisionContactPageState extends State<RevisionContactPage> {
  final SelectContactHelper _selectContactHelper = SelectContactHelper();

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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: ApplicationTextField(
                placeholder: 'Search Contact',
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: widget.contacts.length,
                itemBuilder: (context, index) {
                  Contact contact = widget.contacts[index];
                  return Card(
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    margin: EdgeInsets.zero,
                    color: ApplicationColorsDark.tileColor,
                    child: ListTile(
                      title: Label(contact.name ?? "Not Provided"),
                      subtitle: Subtitle(contact.phoneNumber),
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
