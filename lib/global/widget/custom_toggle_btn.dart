import 'package:bookstar_app/constants/bookstar_color.dart';
import 'package:flutter/cupertino.dart';

class CustomToggleBtn extends StatefulWidget {
  final bool active;

  const CustomToggleBtn({
    super.key,
    required this.active,
  });

  @override
  State<CustomToggleBtn> createState() => _CustomToggleBtnState();
}

class _CustomToggleBtnState extends State<CustomToggleBtn> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.active;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      activeTrackColor: BookstarColor.greyColor6,
      inactiveTrackColor: BookstarColor.greyColor3,
      value: isActive,
      onChanged: (bool newValue) {
        setState(() {
          isActive = newValue;
        });
      },
    );
  }
}
