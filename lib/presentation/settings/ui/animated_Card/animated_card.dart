import 'package:flutter/material.dart';
import 'package:salat_waqt/core/constant/app_contant.dart';
import 'package:salat_waqt/presentation/common/widgets/svg_icons.dart';

class AnimatedCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String svgIconPath;
  const AnimatedCard({super.key, required this.title, required this.subtitle, required this.svgIconPath,});

  @override
  AnimatedCardState createState() => AnimatedCardState();
}

class AnimatedCardState extends State<AnimatedCard> {
  bool _isExpanded = false;
  // Store single selected item
  String? selectedText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        width: double.infinity,
        height: _isExpanded ? 200 : 88,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  SvgIcon(svgPath: AppConstant.icWeat, width: 28, height: 28),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.subtitle,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Spacer(),
                  _isExpanded
                      ? SvgIcon(svgPath: AppConstant.icArrowUp)
                      : SvgIcon(svgPath: AppConstant.icArrowDown),
                ],
              ),
            ),
            if (_isExpanded)
              Expanded(
                child: Column(
                  children: [
                    buildSelectableText("Hanafi"),
                    Divider(color: Colors.black, thickness: 1),
                    buildSelectableText("SHafi,Maliki,Hambli"),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildSelectableText(String text) {
    return InkWell(
      onTap: () {
        setState(() {
          // Toggle selection: Select new item or deselect if already selected
          if (selectedText == text) {
            selectedText = null;
          } else {
            selectedText = text;
          }
        });
      },
      child: Container(
        color: selectedText == text ? Colors.grey[300] : null,
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyle(fontSize: 16)),
            if (selectedText == text) Icon(Icons.check),
          ],
        ),
      ),
    );
  }
}
