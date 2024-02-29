import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants.dart';

class SignUpScreenTopImage extends StatefulWidget {
  const SignUpScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpScreenTopImage> createState() => _SignUpScreenTopImageState();
}

class _SignUpScreenTopImageState extends State<SignUpScreenTopImage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sign Up".toUpperCase(),
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.deepPurple),
        ),
        const SizedBox(height: defaultPadding),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: SvgPicture.asset("assets/icons/signup.svg"),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
