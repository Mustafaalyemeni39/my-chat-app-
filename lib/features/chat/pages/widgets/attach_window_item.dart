import 'package:flutter/material.dart';

import '../../../../global/theme/style.dart';
class AttachWindowItem extends StatelessWidget {
  const AttachWindowItem({Key? key, this.icon, this.color, this.title, this.onTap}) : super(key: key);
  final IconData? icon;
  final Color? color;
  final String? title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: color),
            child: Icon(icon),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "$title",
            style: const TextStyle(color: greyColor, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
