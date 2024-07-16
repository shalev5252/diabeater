
import 'package:diabeater/models/screenSizeFit.dart';
import 'package:diabeater/models/shared_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


Widget ArticleContainer(String title, String description, double review_stars, String picture_path){
  //to move short_description (description now), review_rating(rating now) and picture to parameters
  return Center(child: Container(
    height: SizeConfig.blockSizeVertical*30,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0)),
        border: Border.all(color: chosenBlue),
        color: Colors.white),
    child: SingleChildScrollView(
    child:
      Column(
      children: [
        SizedBox(height: SizeConfig.blockSizeVertical * 2),
        Center(child:
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            overflow: TextOverflow.ellipsis,

          ),
        maxLines: 2,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        ),),
        Flex(
          direction: Axis.horizontal,
          children: [
            SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  description,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 2, right: SizeConfig.blockSizeHorizontal * 3),
              child: Image.asset(
              picture_path,
              width: SizeConfig.blockSizeHorizontal * 20,
              height: SizeConfig.blockSizeVertical * 20,
              alignment: Alignment.center,
            )),
          ],
        ),
        RatingBarIndicator(
          rating: review_stars,
          itemBuilder: (context, index) => Icon(
            Icons.favorite,
            color: Colors.red,
            /*
            Icons.star,
            color: Colors.amber,
            //if we want stars use this.*/
          ),
          itemCount: 5,
          itemSize: SizeConfig.blockSizeVertical * 3,
          direction: Axis.horizontal,
        ),
      ],
    ),),
  ));


  /*return Container(
    width: SizeConfig.blockSizeHorizontal*90,
      decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
      topRight: Radius.circular(10.0),
    bottomRight: Radius.circular(10.0),
    topLeft: Radius.circular(10.0),
    bottomLeft: Radius.circular(10.0)),
    border: Border.all(color: chosenBlue),
    color: Colors.white),
      child: Column(
      children: [
      Text(title,
        style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 22.0,
      ),), //to define font and color
        Row(
          children: [
            Column(
              children: [
            Expanded(
            child: SingleChildScrollView(
            child:Flexible(child:
                Text(description,
                style: TextStyle(
                  color: Colors.black,),
                )))),
                RatingBarIndicator(
                  rating: review_stars,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: SizeConfig.blockSizeVertical * 5, //maybe change this
                  direction: Axis.horizontal,
                ),
                //to add rating here https://pub.dev/packages/flutter_rating_bar
              ],
            ),
            SizedBox(width: SizeConfig.blockSizeHorizontal * 5,),
            Image.asset(picture_path,
              width: SizeConfig.blockSizeHorizontal * 30,
              height: SizeConfig.blockSizeVertical * 30,
              alignment: Alignment.center,)
            //to insert image
          ],
        )
  ],
  ),

  );

*/
}




/*

Container(
                width: SizeConfig.blockSizeHorizontal * 90,
                height: SizeConfig.blockSizeVertical * 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                  border: Border.all(color: chosenBlue),
                  color: Colors.white,
                ),
                child: Text(
                  'Today\'s goal',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                )),

 */