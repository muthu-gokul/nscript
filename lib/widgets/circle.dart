import 'package:flutter/material.dart';
class Circle extends StatelessWidget {
  double hei;
  Color color;
  Widget? widget;
  EdgeInsets margin;
  List<BoxShadow> bs;
  double borderWidth;
  Color borderColor;
  Circle({required this.hei,required this.color,this.widget=null,this.margin=const EdgeInsets.only(left: 0),
  this.bs=const [],this.borderWidth=0,this.borderColor=Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hei,
      width: hei,
      margin: margin,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: bs,
          border: Border.all(color: borderColor,width: borderWidth)
      ),
      child: widget==null?Container():widget,
    );
  }
}
