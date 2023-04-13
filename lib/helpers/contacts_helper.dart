import 'package:flutter/cupertino.dart';
import 'package:the_broadcaster/helpers/broadcast_page_helper.dart';
import 'package:the_broadcaster/helpers/global_file_instances.dart';
import 'package:the_broadcaster/serviceLocator.dart';

import '../models/contact.dart';
import '../utils.dart';

class SelectContactHelper {
  SelectContactHelper();

  final ScrollController scrollController = ScrollController();

  selectFirst100(List<Contact> contacts) {
    for (int i = 0; i < getRange(contacts); i++) {
      contacts[i].toggleIsSelected(!contacts[i].isSelected.value);
    }

    rebuiltNeededStream.add('BroadCastPage');
    rebuiltNeededStream.add('RevisionBroadCastPage');
  }

  // void scrollTo(String text){
  //    scrollController.
  // }

  // selectLast100(List<Contact> contacts) {
  //   for (var i = getRange(contacts); i >= 1; i--) {
  //     print(i);
  //     contacts[i].toggleIsSelected(!contacts[i].isSelected.value);
  //   }

  //   serviceLocator.get<BroadCastHelper>().loadData();
  //   serviceLocator.get<BroadCastHelper>().updateMap();
  // }

  int getRange(List<Contact> contacts) {
    if (contacts.length > 100) {
      return 100;
    } else {
      return contacts.length;
    }
  }
}
