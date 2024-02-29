import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class SocalIcon extends StatefulWidget {
  final String? iconSrc;
  final Function? press;
  const SocalIcon({
    Key? key,
    this.iconSrc,
    this.press,
  }) : super(key: key);

  @override
  State<SocalIcon> createState() => _SocalIconState();
}

class _SocalIconState extends State<SocalIcon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press as void Function()?,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: kPrimaryLightColor,
          ),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          widget.iconSrc!,
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}
