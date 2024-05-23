import 'package:flutter/material.dart';

Color createColorFromHashCode(int hashCode){
  List<int> hashCodeInts = hashCode.toString().split('').map((e) => num.parse(e).toInt()).toList();
  int takeSize = (hashCodeInts.length~/3);
  int r = num.parse(hashCodeInts.join('').substring(0, takeSize)).toInt();
  int g = num.parse(hashCodeInts.join('').substring(takeSize+1, takeSize+takeSize+1)).toInt();
  int b = num.parse(hashCodeInts.join('').substring(takeSize+takeSize+1)).toInt();
  debugPrint("Created Color: $r, $g, $b");
  return Color.fromARGB(255, r, g, b);
}