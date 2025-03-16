import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salat_waqt/core/config/salat_waqt_screen.dart';

class SvgIcon extends StatelessWidget {
  final String svgPath;
  final double? height;
  final double? width;
  final Color? color;
  final VoidCallback? onTap;

  const SvgIcon({
    super.key,
    required this.svgPath,
    this.height,
    this.width,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return onTap != null
        ? InkWell(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          splashColor: Colors.transparent,
          onTap: onTap,
          child: SvgPicture.asset(
            svgPath,
            height: height?.px ?? 24.px,
            width: width?.px ?? 24.px,
            colorFilter:
                color != null
                    ? ColorFilter.mode(color!, BlendMode.srcIn)
                    : null,
          ),
        )
        : SvgPicture.asset(
          svgPath,
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        );
  }
}
