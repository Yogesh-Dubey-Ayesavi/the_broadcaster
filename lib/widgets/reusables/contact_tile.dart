// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:the_broadcaster/helpers/broadcast_page_helper.dart';
// import 'package:the_broadcaster/helpers/contacts_helper.dart';
// import 'package:the_broadcaster/helpers/global_file_instances.dart';
// import 'package:the_broadcaster/revision/revision_helpers.dart/broadcast_helper.dart';
// import 'package:the_broadcaster/serviceLocator.dart';
// import 'package:the_broadcaster/widgets/select_contacts_page.dart';

// import '../../default_colors.dart';
// import '../../models/contact.dart';
// import '../text_widgets.dart';

// class ContactTile extends StatelessWidget {
//   const ContactTile(
//     this.contact, {
//     super.key,
//     required this.fileName,
//     this.revisionHelper,
//     this.isReadOnly = false,
//   });

//   final Contact contact;
//   final String fileName;
//   final RevisionBroadCastHelper? revisionHelper;

//   bool get isExclusive => isReadOnly == false && revisionHelper != null;

//   @override
//   Widget build(BuildContext context) {
//     // return Card(
//     //   shape: BeveledRectangleBorder(
//     //     borderRadius: BorderRadius.circular(0.0),
//     //   ),
//     //   margin: EdgeInsets.zero,
//     //   color: ApplicationColorsDark.tileColor,
//     //   child: ListTile(
//     //     leading: isReadOnly == false
//     //         ? ValueListenableBuilder(
//     //             valueListenable: contact.isSelected,
//     //             builder: (context, value, child) {
//     //               return Checkbox(
//     //                   value: value,
//     //                   onChanged: (val) {
//     //                     if (val != null) {
//     //                       contact.toggleIsSelected(val);
//     //                       // // serviceLocator.get<BroadCastHelper>().updateMap();
//     //                       // if (isExclusive) {
//     //                       //   revisionHelper?.loadData();
//     //                       // } else {
//     //                       //   Contact? cont = serviceLocator
//     //                       //       .get<GlobalFileHelper>()
//     //                       //       .fileMap[fileName]
//     //                       //       ?.singleWhere((cont) =>
//     //                       //           contact.phoneNumber == cont.phoneNumber);
//     //                       //   cont?.toggleIsSelected(val);
//     //                       //   serviceLocator.get<BroadCastHelper>().loadData();
//     //                       // }
//     //                     }
//     //                   });
//     //             },
//     //           )
//     //         : null,
//     //     title: Label(contact.name ?? "Not Provided"),
//     //     subtitle: Subtitle(contact.phoneNumber),
//     //   ),
//     // );
//   }
// }
