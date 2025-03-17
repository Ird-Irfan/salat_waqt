// import 'package:flutter/material.dart';
// import 'package:salat_waqt/core/utility/utility.dart';

// class CustomSwitch extends StatelessWidget {
//   final bool switchValue;
//   final Function(bool) onSwitchChanged;

//   const CustomSwitch({
//     super.key,
//     required this.switchValue,
//     required this.onSwitchChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Transform.scale(
//       scale: 0.75,
//       alignment: Alignment.center,
//       child: Switch(
//         value: switchValue,
//         onChanged: onSwitchChanged,
//         activeColor: context.color.switchGlowColor,
//         activeTrackColor: Colors.transparent,
//         inactiveThumbColor: Colors.grey[400],
//         inactiveTrackColor: Colors.transparent,
//         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         splashRadius: 8,
//         thumbIcon: MaterialStateProperty.resolveWith((states) {
//           return Icon(
//             Icons.circle,
//             size: 12,
//             color:
//                 switchValue ? context.color.switchGlowColor : Colors.grey[400],
//           );
//         }),
//         trackOutlineWidth: const MaterialStatePropertyAll(1.5),
//         trackOutlineColor: MaterialStateProperty.resolveWith((states) {
//           if (states.contains(MaterialState.selected)) {
//             return context.color.switchGlowColor;
//           }
//           return Colors.grey[400];
//         }),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:salat_waqt/core/utility/utility.dart';

class CustomSwitch extends StatelessWidget {
  final bool switchValue;
  final Function(bool) onSwitchChanged;

  const CustomSwitch({
    super.key,
    required this.switchValue,
    required this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.75,
      alignment: Alignment.center,
      child: Switch(
        value: switchValue,
        onChanged: onSwitchChanged,
        activeColor: context.color.switchGlowColor,
        activeTrackColor: Colors.transparent,
        inactiveThumbColor: Colors.grey[400],
        inactiveTrackColor: Colors.transparent,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashRadius: 10,
        thumbIcon: MaterialStateProperty.resolveWith((states) {
          return Icon(
            Icons.circle,
            size: 12, // এখানে সাইজ কমানো হয়েছে (আগে ছিল 16)
            color:
                switchValue ? context.color.switchGlowColor : Colors.grey[400],
          );
        }),
        trackOutlineWidth: const MaterialStatePropertyAll(1.5),
        trackOutlineColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return context.color.switchGlowColor;
          }
          return Colors.grey[400];
        }),
      ),
    );
  }
}
