import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:the_broadcaster/database/local_database.dart';
import 'package:the_broadcaster/default_colors.dart';
import 'package:the_broadcaster/models/broadcast.dart';
import 'package:intl/intl.dart';
import 'package:the_broadcaster/revision/revision_broadcast_page.dart';
import 'package:the_broadcaster/serviceLocator.dart';
import '../text_widgets.dart';

class PreviousBroadcastCard extends StatefulWidget {
  const PreviousBroadcastCard(this._broadCast, {super.key});

  final BroadCast _broadCast;

  @override
  State<PreviousBroadcastCard> createState() => _PreviousBroadcastCardState();
}

class _PreviousBroadcastCardState extends State<PreviousBroadcastCard> {
  void onDismiss() {
    serviceLocator.get<LocalDatabase>().broadCasts.value.removeAt(serviceLocator
        .get<LocalDatabase>()
        .broadCasts
        .value
        .indexOf(widget._broadCast));
    serviceLocator.get<LocalDatabase>().deleteBroadCast(widget._broadCast);
    serviceLocator.get<LocalDatabase>().updateBroadCast();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
        key: ValueKey(1),

        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(
            onDismissed: onDismiss,
            closeOnCancel: true,
          ),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: CupertinoIcons.delete,
              label: 'Delete',
            ),
          ],
        ),

        // The end action pane is the one at the right or the bottom side.
        // endActionPane: ActionPane(
        //   dismissible: DismissiblePane(onDismissed: () {}),
        //   motion: ScrollMotion(),
        //   children: [
        //     SlidableAction(
        //       onPressed: (context) {},
        //       backgroundColor: ApplicationColorsDark.applicationGreen,
        //       foregroundColor: Colors.white,
        //       label: 'Accept',
        //     ),
        //   ],
        // ),
        child: Card(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          margin: EdgeInsets.zero,
          color: ApplicationColorsDark.tileColor,
          child: ListTile(
            leading: Icon(
              CupertinoIcons.doc,
              color: ApplicationColorsDark.applicationBlue,
            ),
            title: Label(DateFormat('dd MMM yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(
                    widget._broadCast.createdAt))),
            subtitle: Subtitle(widget._broadCast.message),
            trailing: ValueListenableBuilder(
              valueListenable: widget._broadCast.hasContactsLoaded,
              builder: (context, value, child) {
                if (value) {
                  return IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RevisionBroadCastPage(widget._broadCast)));
                      },
                      icon: Icon(
                        CupertinoIcons.chevron_right_circle,
                        color: ApplicationColorsDark.applicationBlue,
                      ));
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ));
  }
}
