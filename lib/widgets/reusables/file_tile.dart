// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:the_broadcaster/helpers/global_file_instances.dart';
// import 'package:the_broadcaster/models/broadcast.dart';
// import 'package:the_broadcaster/revision/revision_helpers.dart/broadcast_helper.dart';
// import 'package:the_broadcaster/serviceLocator.dart';
// import 'package:the_broadcaster/widgets/select_contacts_page.dart';

// import '../../default_colors.dart';
// import '../../models/contact.dart';
// import '../text_widgets.dart';

// class FileTile extends StatelessWidget {
//   const FileTile(
//     this.file, {
//     required this.fileName,
//     this.serveAsFileManager = true,
//     this.onRebuilt,
//     this.revisionHelper,
//     this.isReadOnly = false,
//     super.key,
//   });

//   final String fileName;
//   final File file;
//   final bool serveAsFileManager;
//   // final BroadCast? broadCast;
//   final bool isReadOnly;
//   final RevisionBroadCastHelper? revisionHelper;
//   final VoidCallback? onRebuilt;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: BeveledRectangleBorder(
//         borderRadius: BorderRadius.circular(0.0),
//       ),
//       margin: EdgeInsets.zero,
//       color: ApplicationColorsDark.tileColor,
//       child: ListTile(
//         leading: Icon(
//           CupertinoIcons.doc,
//           color: ApplicationColorsDark.applicationBlue,
//         ),
//         title: Subtitle(fileName),
//         trailing: serveAsFileManager == true
//             ? PopupMenuButton(
//                 icon: Icon(
//                   Icons.menu_open_rounded,
//                   color: ApplicationColorsDark.applicationBlue,
//                 ),
//                 color: const Color(0xff191919),
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(20.0),
//                   ),
//                 ),
//                 onSelected: (value) => {
//                       if (value == 0)
//                         {
//                           showDialog(
//                             context: context,
//                             builder: (context) {
//                               return AlertDialog(
//                                 backgroundColor:
//                                     ApplicationColorsDark.secondaryColor,
//                                 shape: const RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(20.0),
//                                   ),
//                                 ),
//                                 title: Label(
//                                   'Would you like to delete file $fileName',
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     child: Subtitle("Yes"),
//                                     onPressed: () async {
//                                       serviceLocator
//                                           .get<GlobalFileHelper>()
//                                           .removeFile(file)
//                                           .then((value) {
//                                         Navigator.pop(context);
//                                         onRebuilt?.call();
//                                       });
//                                     },
//                                   ),
//                                   TextButton(
//                                     child: Subtitle("No"),
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                   )
//                                 ],
//                               );
//                             },
//                           )
//                         }
//                     },
//                 itemBuilder: (context) => [
//                       PopupMenuItem<int>(
//                         value: 0,
//                         child: Subtitle(
//                           'Delete File',
//                           color: ApplicationColorsDark.titleColor,
//                         ),
//                       ),
//                     ])
//             : IconButton(
//                 onPressed: () {
//                   try {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ContactsPage(
                                     
//                                 )));
//                   } catch (e) {
//                     print(e);
//                   }
//                 },
//                 icon: Icon(
//                   CupertinoIcons.chevron_right_circle,
//                   color: ApplicationColorsDark.applicationBlue,
//                 )),
//       ),
//     );
//   }
// }
