import 'package:flutter/material.dart';
import 'package:myphone_admin/Widgets/text.dart';
import 'package:sizer/sizer.dart';

class InformationalBit extends StatelessWidget {
  final String dataPoint;
  final String information;
  const InformationalBit({
    super.key,
    required this.dataPoint,
    required this.information,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: (100.w - 42) / 2,
          child: MyText(
            text: dataPoint,
            size: 18,
            weight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        SizedBox(
          width: (100.w - 42) / 2,
          child: MyText(
            text: information,
            size: 14,
            weight: FontWeight.normal,
            color: Colors.black,
            align: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
