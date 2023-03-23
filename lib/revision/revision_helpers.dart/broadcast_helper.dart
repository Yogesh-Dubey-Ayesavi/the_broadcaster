import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:the_broadcaster/database/local_database.dart';
import 'package:the_broadcaster/helpers/broadcast_page_helper.dart';
import 'package:the_broadcaster/helpers/global_file_instances.dart';
import 'package:the_broadcaster/models/broadcast.dart';
import 'package:the_broadcaster/serviceLocator.dart';
import 'package:uuid/uuid.dart';

import '../../models/contact.dart';
import '../../utils.dart';
import '../../widgets/select_file_page.dart';

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

  ValueNotifier<List<Contact>> sentMessageInstance = ValueNotifier([]);

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

      if (getInstanceVariables().isNotEmpty) {
        for (var i = 0; i < contactRecipients.length; i++) {
          print(getCustomMessage(controller.text, contactRecipients[i]));
          await sendSMS(
                  message:
                      getCustomMessage(controller.text, contactRecipients[i]),
                  recipients: recipients,
                  sendDirect: true)
              .then((value) => updateSentMessageInstance(contactRecipients[i]));
        }
        serviceLocator
            .get<LocalDatabase>()
            .insertContacts(broadCast, _getContacts(), _getMap());
      } else {
        sendSMS(
          message: controller.text,
          recipients: recipients,
        ).then((value) {
          serviceLocator
              .get<LocalDatabase>()
              .insertContacts(broadCast, _getContacts(), _getMap());
        });
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

  updateSentMessageInstance(Contact contact) {
    final List<Contact> newList = List.from(sentMessageInstance.value);
    newList.add(contact);
    sentMessageInstance.value = newList;
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

  List<String> getInstanceVariables() {
    final List<String> list = [];
    final regex = RegExp(r'\$(\w)+').allMatches(controller.text);
    for (var element in regex) {
      list.add(
          controller.text.substring(element.start, element.end).substring(1));
    }
    return list;
  }

  void onPressSelectContacts(BuildContext context) {
    final list = getInstanceVariables();
    final Map<String, List<Contact>> resMap = {};
    for (var element in newRecipients.value.entries) {
      final keys = serviceLocator
          .get<GlobalFileHelper>()
          .getParser(element.key)
          ?.fieldMap
          .keys;
      list.remove('phoneNumber');
      final newList = keys?.toList();
      newList?.remove('phoneNumber');
      if (newList != null && listContainsAll(newList, list)) {
        resMap.putIfAbsent(element.key, () => element.value);
      }
      // print('$list , ${newList}');
    }
    // print(resMap);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => FilePage(contactsMap: resMap)));
  }

  bool listContainsAll<T>(List<T> a, List<T> b) {
    final setA = Set.of(a);
    return setA.containsAll(b);
  }

  String getCustomMessage(String message, Contact contact) {
    return message.replaceAllMapped(RegExp(r'\$(\w)+'), (match) {
      return '${contact.fieldMap[(match.group(0)?.substring(1))]}';
    });
  }
}
