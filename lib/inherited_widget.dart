import 'package:flutter/material.dart';
import 'package:the_broadcaster/helpers/broadcast_page_helper.dart';

class InheritedInstance extends InheritedWidget {
  InheritedInstance({Key? key, required this.child})
      : super(key: key, child: child);

  @override
  final Widget child;

  final ValueNotifier<BroadCastHelper?> broadCastHelper = ValueNotifier(null);

  static InheritedInstance of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedInstance>()!;
  }

  @override
  bool updateShouldNotify(InheritedInstance oldWidget) {
    return true;
  }
}
