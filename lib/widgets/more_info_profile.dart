import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:the_broadcaster/widgets/text_widgets.dart';

import '../models/contact.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget(this.contact, {super.key});

  final Contact contact;

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SecondaryHeadline(
            widget.contact.name ?? widget.contact.phoneNumber),
      ),
      body: Center(
        child: Caption(widget.contact.fieldMap.toString()),
      ),
    );
  }
}
