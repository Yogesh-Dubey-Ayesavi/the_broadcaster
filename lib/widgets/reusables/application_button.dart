import 'package:flutter/cupertino.dart';

import '../text_widgets.dart';

class ApplicationFilledButton extends StatefulWidget {
  
  final Function()? ontap;
  final String buttonlabel;
  final BorderRadius? radius;
  final bool? active;
  final bool? showIndicator;

  const ApplicationFilledButton(
      {Key? key,
      this.ontap,
      this.showIndicator,
      this.active = false,
      required this.buttonlabel,
      this.radius})
      : super(
          key: key,
        );

  @override
  State<ApplicationFilledButton> createState() =>
      _ApplicationFilledButtonState();
}

class _ApplicationFilledButtonState extends State<ApplicationFilledButton> {
  final ValueNotifier<bool> _isIndicatorVisible = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width / 1,
      child: CupertinoButton.filled(
          borderRadius: widget.radius ?? BorderRadius.circular(10),
          padding: EdgeInsets.zero,
          onPressed: widget.active == true
              ? () async {
                  widget.showIndicator == true
                      ? _isIndicatorVisible.value = true
                      : null;
                  if (widget.ontap != null) {
                    dynamic result = await widget.ontap!();
                    result == 200 ? _isIndicatorVisible.value = false : null;
                  }
                }
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Label(widget.buttonlabel),
              ValueListenableBuilder(
                valueListenable: _isIndicatorVisible,
                builder: (context, value, child) {
                  switch (value as bool) {
                    case true:
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: CupertinoActivityIndicator(),
                      );
                    default:
                      return const SizedBox();
                  }
                },
              )
            ],
          )),
    );
  }
}
