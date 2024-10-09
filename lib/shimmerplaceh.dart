import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShimmerPlaceholder extends StatelessWidget{
  const ShimmerPlaceholder({Key? key,this.height,this.width}):super(key:key);
  final double? height,width;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.4),
    borderRadius: const BorderRadius.all(Radius.circular(8))
    ),

    );
  }
}