import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../default_colors.dart';
import 'package:flutter/cupertino.dart';

class Headline extends StatelessWidget {
  final String input;
  const Headline(
    this.input, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      input,
      style: TextStyle(
          color: ApplicationColorsDark.titleColor,
          fontWeight: FontWeight.bold,
          fontFamily: "Poppins",
          fontSize: 30),
    );
  }
}

class SecondaryHeadline extends StatelessWidget {
  final String input;
  final Color? color;
  const SecondaryHeadline(this.input, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      input,
      style: TextStyle(
          color: color ?? ApplicationColorsDark.titleColor,
          fontWeight: FontWeight.bold,
          fontFamily: "Poppins",
          overflow: TextOverflow.ellipsis,
          fontSize: 20),
    );
  }
}

class Label extends StatelessWidget {
  final String input;
  final Color? color;
  final int? maxLines;

  const Label(this.input, {Key? key, this.color, this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      input,
      maxLines: maxLines,
      style: TextStyle(
          fontSize: 16,
          fontFamily: "Poppins",
          color: color ?? ApplicationColorsDark.titleColor,
          fontWeight: FontWeight.w500),
    );
  }
}

class Subtitle extends StatelessWidget {
  final String? input;
  final TextAlign? alignment;
  final Color color;
  final int? maxLines;

  const Subtitle(
    this.input, {
    Key? key,
    this.alignment = TextAlign.start,
    this.color = Colors.white54,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      input ?? "Not defined",
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 14,
        fontFamily: "Poppins",
        color: color,
        fontWeight: FontWeight.w300,
      ),
      textAlign: alignment,
    );
  }
}

class Caption extends StatelessWidget {
  final String? input;
  final Color color;
  final int? maxLines;
  const Caption(this.input,
      {Key? key, this.color = Colors.white54, this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      input ?? "",
      style: TextStyle(
          fontSize: 12,
          fontFamily: "Poppins",
          color: color,
          fontWeight: FontWeight.w400),
      maxLines: maxLines,
    );
  }
}

class ApplicationTextField extends StatelessWidget {
  final String? placeholder;
  final Widget? icon;
  final bool? disabled;
  final Color? backgroundcolor;
  final TextInputType? keyboardtype;
  final TextEditingController? controller;
  final Widget? trailing;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? action;
  final Function(String value)? onChanged;
  final TextCapitalization captitalization;
  final List<TextInputFormatter> inputFormatters;

  const ApplicationTextField(
      {Key? key,
      required this.placeholder,
      this.icon,
      this.maxLength,
      this.trailing,
      this.maxLines,
      this.minLines,
      this.controller,
      this.onChanged,
      this.disabled = false,
      this.backgroundcolor,
      this.action,
      this.captitalization = TextCapitalization.none,
      this.inputFormatters = const [],
      this.keyboardtype})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: CupertinoTextField(
          maxLength: maxLength,
          minLines: minLines,
          maxLines: maxLines,
          readOnly: disabled ?? false,
          controller: controller,
          textCapitalization: captitalization,
          placeholderStyle:
              TextStyle(color: ApplicationColorsDark.placeholderColor),
          padding: const EdgeInsets.all(8),
          placeholder: placeholder,
          suffix: trailing,
          inputFormatters: inputFormatters,
          cursorColor: Colors.white,
          style: TextStyle(color: ApplicationColorsDark.titleColor),
          onChanged: (value) {
            onChanged?.call(value);
          },
          prefix:
              Container(margin: const EdgeInsets.only(left: 7), child: icon),
          keyboardType: keyboardtype ?? TextInputType.text,
          textInputAction: action,
          decoration: BoxDecoration(
              color: backgroundcolor ?? ApplicationColorsDark.secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)))),
    );
  }
}
