import 'dart:math';

import 'package:diabeater/models/shared_code.dart';
import 'package:diabeater/screens/recipes/detailed_recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:diabeater/screens/recipes/detailed_recipe.dart';
import 'package:diabeater/models/Recipe.dart';
import 'package:readmore/readmore.dart';

import '../models/FadeInImage333.dart';

class NiceCard extends StatelessWidget {
  NiceCard(this.id, this.title, this.imageUrl, this.description, this.author,
      this.text, this.date, this.rating); //{Key? key}
  // final
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final double rating;

  String author;
  String text; //the body of the recipe
  String date; //last_updated

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsPage(
                    recipe: Recipe(
                        id: id,
                        recipe_title: title,
                        recipe_description: description,
                        recipe_image: imageUrl,
                        author: author,
                        text: text,
                        date: date))));
      },
      child: Container(
        height: 136,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(8.0)),
        // padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReadMoreText(
                          this.title,
                          trimLines: 2,
                          colorClickableText: chosenBlue,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'הראה עוד',
                          trimExpandedText: 'הראה פחות',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                            child: ReadMoreText(
                                "${this.description.substring(0, min(this.description.length, 180))}",
                                trimLines: 2,
                                colorClickableText: chosenBlue,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'הראה עוד',
                                trimExpandedText: 'הראה פחות',
                                style: Theme.of(context).textTheme.bodyMedium)),
                        const SizedBox(height: 8),
                        // Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     Icons.bookmark_border_rounded,
                        //     Icons.share,
                        //     Icons.more_vert
                        //   ].map((e) {
                        //     return InkWell(
                        //       onTap: () {},
                        //       child: Padding(
                        //         padding: const EdgeInsets.only(right: 8.0),
                        //         child: Icon(e, size: 16),
                        //       ),
                        //     );
                        //   }).toList(),
                        // )
                        RatingBarIndicator(
                            rating: this.rating,
                            itemSize: 20.0,
                            itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  /*
            Icons.star,
            color: Colors.amber,
            //if we want stars use this.*/
                                ))
                      ],
                    ))),
            Container(
                width: 136,
                height: 136,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(this.imageUrl),
                      // image: NetworkImage(this.imageUrl),
                    ))),
          ],
        ),
      ),
    );
  }
}
