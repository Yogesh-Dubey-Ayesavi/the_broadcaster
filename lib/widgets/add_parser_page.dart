import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_broadcaster/helpers/global_file_instances.dart';
import 'package:the_broadcaster/helpers/parser_file_helper.dart';
import 'package:the_broadcaster/widgets/parser_properties.dart';
import 'package:the_broadcaster/widgets/reusables/application_button.dart';
import 'package:the_broadcaster/widgets/text_widgets.dart';

import '../default_colors.dart';
import '../helpers/add_parser_helper.dart';
import '../serviceLocator.dart';

class AddParserFilePage extends StatefulWidget {
  const AddParserFilePage({super.key, this.fileName, this.parserFileHelper});

  final String? fileName;
  final ParserFileHelper? parserFileHelper;

  @override
  State<AddParserFilePage> createState() => _AddParserFilePageState();
}

class _AddParserFilePageState extends State<AddParserFilePage> {
  late AddParserHelper _helper;

  bool get isRevision => widget.parserFileHelper != null;

  @override
  void initState() {
    if (isRevision) {
      _helper = AddParserHelper(isRevision: true);
    } else {
      print(widget.fileName);
      _helper = AddParserHelper();
    }
    if (isRevision) {
      _helper.fileName.value = widget.parserFileHelper?.fileName;
      _helper.fieldMap.value = widget.parserFileHelper?.fieldMap ?? {};
      _helper.phoneNumberController.text =
          widget.parserFileHelper?.fieldMap['phoneNumber'] ?? 'phone';
    } else {
      _helper.fileName.value = widget.fileName;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SecondaryHeadline('${isRevision ? "Update" : "Add"} Parser'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (!isRevision) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Label('${widget.fileName}'),
                  )

                  //   Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.max,
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         const Subtitle("FileName : "),
                  //         ValueListenableBuilder(
                  //           valueListenable: _helper.fileName,
                  //           builder: (context, value, child) {
                  //             return DropdownButton<dynamic>(
                  //               style: TextStyle(color: Colors.white),
                  //               dropdownColor:
                  //                   ApplicationColorsDark.secondaryColor,
                  //               borderRadius: BorderRadius.circular(12),

                  //               // Initial Value
                  //               value: widget.fileName ?? value,
                  //               // Down Arrow Icon
                  //               icon: const Icon(Icons.keyboard_arrow_down),

                  //               // Array list of items
                  //               items: serviceLocator
                  //                   .get<GlobalFileHelper>()
                  //                   .files
                  //                   .map((e) => DropdownMenuItem(
                  //                       value: e, child: Caption(e)))
                  //                   .toList(),
                  //               // After selecting the desired option,it will
                  //               // change button value to selected value
                  //               onChanged: (Object? newValue) {
                  //                 _helper.fileName.value = newValue as String;
                  //               },
                  //             );
                  //           },
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                ],
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    color: ApplicationColorsDark.secondaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Subtitle(
                            "PhoneNumber  :",
                          ),
                          Flexible(
                              child: ApplicationTextField(
                            placeholder: "PhoneNumber in csv file",
                            controller: _helper.phoneNumberController,
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _helper.fieldMap,
                  builder: (context, value, child) {
                    final keys = value.keys.toList();
                    // print('rebuilt');
                    return Flexible(
                      child: ListView.builder(
                        itemCount: keys.length,
                        itemBuilder: (context, index) {
                          // print(keys);
                          if (keys[index] != "phoneNumber") {
                            return FieldValueWidget(
                              keys[index],
                              value[keys[index]],
                              helper: _helper,
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    );
                  },
                ),
                Fillers(_helper),
                const SizedBox(
                  height: 10,
                ),
                ApplicationFilledButton(
                  active: true,
                  buttonlabel: !isRevision ? "Add Parser" : "Update Parser",
                  ontap: () {
                    _helper.onAddParser(context,
                        helper: isRevision ? widget.parserFileHelper : null);
                  },
                )
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: serviceLocator.get<GlobalFileHelper>().loader,
            builder: (context, value, child) {
              if (value) {
                return const Center(child: CircularProgressIndicator());
              }
              return const SizedBox();
            },
          )
        ],
      ),
    );
  }
}
