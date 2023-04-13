import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_broadcaster/database/local_database.dart';
import 'package:the_broadcaster/helpers/global_file_instances.dart';
import 'package:the_broadcaster/models/broadcast.dart';
import 'package:the_broadcaster/serviceLocator.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:the_broadcaster/utils.dart';
import '../default_colors.dart';
import '../models/contact.dart';
import 'package:uuid/uuid.dart';

import '../widgets/select_file_page.dart';
import '../widgets/text_widgets.dart';

class BroadCastHelper {
  BroadCastHelper() {
    selectedContactsFileMap.addListener(() {});
  }

  ValueNotifier<Map<String, List<Contact>>> selectedContactsFileMap =
      ValueNotifier({});

  TextEditingController textEditingController = TextEditingController();

  Map<String, List<Contact>> fileMap =
      serviceLocator.get<GlobalFileHelper>().fileMap;

  ValueNotifier<List<Contact>> sentMessageInstance = ValueNotifier([]);

  addContact(Contact contact, String fileName) {
    selectedContactsFileMap.value[fileName]?.add(contact);
    updateMap();
  }

  removeContact(Contact contact, String fileName) {
    selectedContactsFileMap.value[fileName]?.remove(contact);
    updateMap();
  }

  addFile(String fileName) {
    selectedContactsFileMap.value.putIfAbsent(fileName, () => []);
  }

  updateMap() {
    loadData();
    Map<String, List<Contact>> newMap = Map.from(selectedContactsFileMap.value);
    selectedContactsFileMap.value = newMap;
  }

  updateSentMessageInstance(Contact contact) {
    final List<Contact> newList = List.from(sentMessageInstance.value);
    newList.add(contact);
    sentMessageInstance.value = newList;
  }

  loadData() {
    Map<String, List<Contact>> resultMap = {};
    for (var entry in fileMap.entries) {
      List<Contact> selectedContacts = entry.value
          .where((contact) => contact.isSelected.value == true)
          .toList();
      if (selectedContacts.isNotEmpty) {
        resultMap.putIfAbsent(entry.key, () => selectedContacts);
      }
      selectedContactsFileMap.value = resultMap;
    }
  }

  dipose() {
    selectedContactsFileMap.value = {};
    textEditingController.clear();
  }

  Future<bool> sendMessage(BuildContext context) async {
    List<String> recipients = [];
    List<Contact> contacts = [];
    // SmsSender sender = new SmsSender();
    for (var entry in selectedContactsFileMap.value.entries) {
      recipients
          .addAll(entry.value.map((e) => e.phoneNumber.toString()).toList());
      contacts.addAll(entry.value);
    }

    final permission = Permission.sms.request();

    if (textEditingController.text.isNotEmpty && _getContacts().isNotEmpty) {
      if (getInstanceVariables().isNotEmpty) {
        for (var i = 0; i < recipients.length; i++) {
          try {
            sendSMS(
              message:
                  getCustomMessage(textEditingController.text, contacts[i]),
              recipients: [recipients[i]],
              sendDirect: true,
            ).then((value) {
              updateSentMessageInstance(contacts[i]);
            }).onError((error, stackTrace) {
              // print('$error');
            });
          } catch (e) {
            print(e);
            print('$i');
            break;
          }
        }
        return createBroadCast(BroadCast(
          textEditingController.text,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: "u${removeSpecialCharacters(const Uuid().v4())}",
          recipients: _getContacts(),
          mappedContacts: selectedContactsFileMap.value,
        ));
        // getCustomMessage(textEditingController.text, recipients[0]);
      } else {
        if (await permission.isGranted) {
          final res = await sendSMS(
            message: textEditingController.text,
            recipients: recipients,
          );
          if (res != null) {
            return createBroadCast(BroadCast(
              textEditingController.text,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              id: "u${removeSpecialCharacters(const Uuid().v4())}",
              recipients: _getContacts(),
              mappedContacts: selectedContactsFileMap.value,
            ));
          }
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: ApplicationColorsDark.secondaryColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            title: const Subtitle(
              'Message is empty, either contact list. Please add a message and atleast one contact to broadcast',
            ),
            actions: [
              TextButton(
                child: const Subtitle("Yes"),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Subtitle("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
      return false;
    }

    return false;
  }

  List<Contact> _getContacts() {
    List<Contact> contactList = [];
    for (var entry in selectedContactsFileMap.value.entries) {
      contactList.addAll(entry.value);
    }
    return contactList;
  }

  bool createBroadCast(BroadCast broadCast) {
    try {
      serviceLocator.get<LocalDatabase>().addBroadCast(broadCast);
      return true;
    } catch (e) {
      return false;
    }
  }

  List<String> getInstanceVariables() {
    final List<String> list = [];
    final regex = RegExp(r'\$(\w)+').allMatches(textEditingController.text);
    for (var element in regex) {
      list.add(textEditingController.text
          .substring(element.start, element.end)
          .substring(1));
    }
    return list;
  }

  void onPressSelectContacts(BuildContext context) {
    final list = getInstanceVariables();
    final Map<String, List<Contact>> resMap = {};
    for (var element in fileMap.entries) {
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
    //  final regex = RegExp(r'\$(\w)+').allMatches(textEditingController.text);
    // print('hello');

    return message.replaceAllMapped(RegExp(r'\$(\w)+'), (match) {
      return '${contact.fieldMap[(match.group(0)?.substring(1))]}';
    });
  }
}
