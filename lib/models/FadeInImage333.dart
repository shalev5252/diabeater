import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//for loading pics from url from the network so it will look good
FadeInImage FadeInImage333(String url){
  return FadeInImage(
    image: NetworkImage(url),
    fit: BoxFit.cover,
    placeholder: AssetImage('assets/loading.gif'));
}

