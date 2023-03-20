import 'package:flutter/cupertino.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:the_broadcaster/database/local_database.dart';
import 'package:the_broadcaster/helpers/broadcast_page_helper.dart';
import 'package:the_broadcaster/helpers/global_file_instances.dart';
import 'package:the_broadcaster/models/broadcast.dart';
import 'package:the_broadcaster/serviceLocator.dart';
import 'package:uuid/uuid.dart';

import '../../models/contact.dart';
import '../../utils.dart';

class RevisionBroadCastHelper {
  RevisionBroadCastHelper(this.broadCast) {
    init();
  }

  final BroadCast broadCast;

  final ValueNotifier<Map<String, List<Contact>>> oldRecipients =
      ValueNotifier({});

  final ValueNotifier<Map<String, List<Contact>>> newRecipients =
      ValueNotifier({});

  final Map<String, List<Contact>> fileMap =
      serviceLocator.get<GlobalFileHelper>().fileMap;

  TextEditingController controller = TextEditingController();

  init() {
    oldRecipients.value = broadCast.mappedContacts!;
    controller.text = broadCast.message;
    getExclusiveRecipients();
  }

  dispose() {}

  Future<bool> sendMessage() async {
    try {
      List<String> recipients = [];
      List<Contact> contactRecipients = [];

      newRecipients.value.forEach((key, value) {
        contactRecipients.addAll(
            value.where((element) => element.isSelected.value).toList());
      });

      recipients =
          contactRecipients.map((e) => e.phoneNumber.toString()).toList();

      final res = await sendSMS(
        message: controller.text,
        recipients: recipients,
      );

      if (res != null) {
        serviceLocator
            .get<LocalDatabase>()
            .insertContacts(broadCast, _getContacts(), _getMap());
        // print("Inserted Records");
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  List<Contact> _getContacts() {
    List<Contact> contactList = [];
    newRecipients.value.forEach((key, value) {
      contactList
          .addAll(value.where((element) => element.isSelected.value).toList());
    });
    // print("contactlist ${contactList.length}");
    return contactList;
  }

  Map<String, List<Contact>> _getMap() {
    final Map<String, List<Contact>> resMap = {};
    newRecipients.value.forEach((key, value) {
      final list = value.where((element) => element.isSelected.value).toList();
      if (list.isNotEmpty) {
        resMap.putIfAbsent(key, () => list);
      }
    });
    return resMap;
  }

  getExclusiveRecipients() {
    Map<String, List<Contact>> resMap = {};
    oldRecipients.value.forEach((key, value) {
      final map = fileMap;
      if (map.containsKey(key) && map[key] != null) {
        final list = value
            .map((e) => e.phoneNumber)
            .toSet()
            .intersection(map[key]!.map((e) => e.phoneNumber).toSet())
            .toList();
        List<Contact> cont = List.from(map[key]!);
        for (var phoneNumber in list) {
          cont.removeWhere((e) => e.phoneNumber == phoneNumber);
        }
        resMap.putIfAbsent(key, () => cont);
      }
    });
    newRecipients.value = resMap;
  }

  shiftSelectedContacts(String fileName) {
    try {
      // print(_getRange(fileName));

      if (newRecipients.value.containsKey(fileName) &&
          newRecipients.value[fileName] != null) {
        for (var i = 0; i < _getRange(fileName); i++) {
          newRecipients.value[fileName]![i].isSelected.value = true;
        }
      }
    } catch (e) {
      // print(e);
    }
    updateMap();
  }

  updateMap() {
    Map<String, List<Contact>> newMap = Map.from(newRecipients.value);
    newRecipients.value = newMap;
  }

  int _getRange(String fileName) {
    if (newRecipients.value[fileName] != null &&
        newRecipients.value[fileName]!.length > 100) {
      return 100;
    } else {
      return newRecipients.value[fileName]!.length;
    }
  }

  cleanUp() {
    // serviceLocator.get<GlobalFileHelper>().cleanUp();
  }
}
