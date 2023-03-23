import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:the_broadcaster/helpers/parser_file_helper.dart';
import 'package:the_broadcaster/models/broadcast.dart';
import 'package:the_broadcaster/serviceLocator.dart';
import 'package:the_broadcaster/utils.dart';

import '../helpers/global_file_instances.dart';
import '../helpers/parser_helper.dart';
import '../models/contact.dart';

class LocalDatabase {
  LocalDatabase() {
    init();
  }

  late Database _database;

  Database get database => _database;

  ValueNotifier<List<BroadCast>> broadCasts = ValueNotifier([]);

  ValueNotifier<List<File>> files = ValueNotifier([]);

  Map<String, List<Contact>> fileMap = {};

  void init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'chatting.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        db.execute(
            'CREATE TABLE broadcasts (id text PRIMARY KEY, createdAt int , message text  )');
        createParserTable();
      },
    );
    print(await fetchParsers());
    serviceLocator.get<GlobalFileHelper>();

    broadCasts.value = await fetchBroadCasts();
    broadCasts.addListener(() {
      // print("value changed");
    });
    getContactEntriesForBroadCasts();
    // serviceLocator.get<>()
    // serviceLocator.get<ParserHelper>();
  }

  Future<List<BroadCast>> fetchBroadCasts() async {
    try {
      return await database.transaction((txn) async {
        return (await txn.query('broadcasts')).map((e) {
          // print(e);
          return BroadCast(e['message'] as String,
              createdAt: e['createdAt'] as int, id: e["id"] as String);
        }).toList();
      });
    } catch (e) {
      return [];
    }
  }

  void addBroadCast(BroadCast broadCast) async {
    try {
      await database.transaction((txn) async {
        final map = broadCast.toJson();
        map.remove('recipients');
        await txn.insert("broadcasts", map);
        await createBroadcastContact(broadCast);
      });
    } catch (e) {}
  }

  createBroadcastContact(BroadCast broadCast) async {
    database.transaction((txn) async {
      await txn.execute(
          "CREATE TABLE ${broadCast.id.toString()}(fileName text,name text,phoneNumber text )");
      // print('broadCastContact created');
      addContact(broadCast);
    });
  }

  updateBroadCast() {
    List<BroadCast> newList = List.from(broadCasts.value);
    broadCasts.value = newList;
  }

  void addContact(BroadCast broadCast) async {
    database.transaction((txn) async {
      final batch = txn.batch();
      // print(broadCast.recipients);
      final map = broadCast.toJson();
      for (int i = 0; i < broadCast.recipients.length; i++) {
        final map = broadCast.recipients[i].toJson();
        batch.insert("${broadCast.id}", map);
      }
      await batch.commit();
      broadCast.hasContactsLoaded.value = true;
      broadCasts.value.add(broadCast);
      updateBroadCast();
      // print('broadCastContact contacts added');
    });
  }

  void insertContacts(BroadCast broadCast, List<Contact> recipients,
      Map<String, List<Contact>> mappedContacts) async {
    database.transaction((txn) async {
      final batch = txn.batch();

      final map = broadCast.toJson();
      for (int i = 0; i < recipients.length; i++) {
        // print(i);
        final map = recipients[i].toJson();
        batch.insert("${broadCast.id}", map);
      }
      await batch.commit();
      final newList = [...broadCast.recipients, ...recipients];
      // print(newList);

      final Map<String, List<Contact>> newMap = {};
      mappedContacts.forEach((key, value) {
        if (value.isNotEmpty) {
          if (broadCast.mappedContacts != null &&
              broadCast.mappedContacts!.containsKey(key)) {
            newMap.putIfAbsent(
                key,
                () => [
                      ...?broadCast.mappedContacts![key],
                      ...?mappedContacts[key]
                    ]);
          } else {
            newMap.putIfAbsent(key, () => mappedContacts[key]!);
          }
        }
      });

      final BroadCast newBroadCast = BroadCast(
        broadCast.message,
        createdAt: broadCast.createdAt,
        recipients: newList,
        id: broadCast.id,
        mappedContacts: newMap,
      );
      broadCasts.value[broadCasts.value
          .indexWhere((element) => element.id == broadCast.id)] = newBroadCast;
      newBroadCast.hasContactsLoaded.value = true;
      updateBroadCast();

      // print('broadCastContact contacts added');
    });
  }

  void deleteBroadCast(BroadCast broadCast) {
    database.transaction((txn) async {
      await txn.delete('broadcasts', where: 'id= "${broadCast.id}"');
      await txn.execute("DROP table ${broadCast.id} ");
      // print('broadCastContact deleted');
    });
  }

  getContactEntriesForBroadCasts() async {
    // compute(getEntries, 'null');
    await getEntries();
  }

  Future<bool> getEntries() async {
    for (var broadCast in broadCasts.value) {
      final resList = await getMappedFileNameAndContacts(broadCast);
      List<Contact> list = [];
      for (var entry in resList.entries) {
        list.addAll(entry.value);
      }
      // print(broadCasts.value.indexOf(broadCast));

      BroadCast newBroadCast = broadCasts
          .value[broadCasts.value.indexOf(broadCast)]
          .copyWith(recipients: list, mappedContacts: resList);

      broadCasts.value[broadCasts.value.indexOf(broadCast)] = newBroadCast;

      broadCasts.value[broadCasts.value.indexOf(newBroadCast)].hasContactsLoaded
          .value = true;

      rebuiltNeededStream.add('MainPage');
    }
    return true;
  }

  Future<Map<String, List<Contact>>> getMappedFileNameAndContacts(
      BroadCast broadCast) async {
    final Map<String, List<Contact>> resMap = {};
    return await database.transaction((txn) async {
      final resList = (await txn
              .query("${broadCast.id}", distinct: true, columns: ["fileName"]))
          .map((e) => e['fileName'] as String)
          .toList();
      final mapEntries = resList.map((e) async {
        final contactList =
            (await txn.query("${broadCast.id}", where: 'fileName = "${e}"'))
                .map((e) {
          // print(e);

          return Contact(
              e['phoneNumber'] != null ? e['phoneNumber'] as String : "",
              name: e['name'] as String,
              fileName: e['fileName'] as String);
        }).toList();
        resMap.putIfAbsent(e, () => contactList);
        return MapEntry(e, contactList);
      }).toList();
      resMap.addEntries(await Future.wait(mapEntries));
      return resMap;
    });
  }

  void createParserTable() async {
    database.transaction((txn) async {
      await txn.execute(
          'create table if not exists parsers(fileName text, fieldMap text)');
    });
  }

  Future<List<ParserFileHelper>> fetchParsers() async {
    return database.transaction((txn) async {
      final list = await txn.query('parsers');

      final another = list
          .map((e) => ParserFileHelper(
              e['fileName'] as String, jsonDecode(e['fieldMap'] as String)))
          .toList();
      serviceLocator.get<ParserHelper>().parsers.value = another;

      return another;
    });
  }

  void insertParserFileHelper(ParserFileHelper helper) {
    createParserTable();
    database.transaction((txn) async {
      await txn.execute(
          "insert into parsers (fileName,fieldMap) Values('${helper.fileName}','${jsonEncode(helper.fieldMap)}' ) ");
    });
  }

  void removeFileParser(String fileName) {
    database.transaction((txn) async {
      await txn.delete('parsers', where: 'fileName = "$fileName" ');
    });
  }

  void updateParser(ParserFileHelper helper) {
    database.transaction((txn) async {
      print('updation');
      await txn.execute(
          "update parsers set fieldMap = '${jsonEncode(helper.fieldMap)}' where fileName = '${helper.fileName}'");
    });
  }
}
