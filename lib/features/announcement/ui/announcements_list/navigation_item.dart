import 'package:flutter/material.dart';
import 'package:vocel/common/utils/colors.dart' as constants;

class NavigationItem extends StatelessWidget {
  const NavigationItem({Key? key, required this.name, required this.leadingIcon, required this.onPressedFunction}) : super(key: key);

  final String name;
  final IconData leadingIcon;
  final Function() onPressedFunction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressedFunction,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 8, 0, 8),
            child: Row(
              children: [
                Icon(leadingIcon, size: 15, color: Colors.blueGrey,),
                const SizedBox(width: 20,),
                Text(name, style: const TextStyle(fontSize: 18, color: Colors.blueGrey),)
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}
