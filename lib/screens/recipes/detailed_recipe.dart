import 'package:flutter/material.dart';
import 'package:diabeater/models/Recipe.dart';

class DetailsPage extends StatelessWidget {
  final Recipe recipe;

  DetailsPage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              title: Text(recipe.recipe_title),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: recipe.id,
                  child: FadeInImage(
                      image: NetworkImage(recipe.recipe_image),
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/loading.gif')),
                ),
              ),
            ),
          ];
        },
        body: Container(
          color: Theme.of(context).canvasColor,
          padding: EdgeInsets.only(top: 8.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  //apply padding horizontal or vertical only
                  child: Text(recipe.recipe_description,
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                ),
                Divider(color: Colors.black, endIndent: 40.0, indent: 40.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  //apply padding horizontal or vertical only
                  child: Text(recipe.author + "  " + recipe.date,
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
                Divider(color: Colors.black, endIndent: 40.0, indent: 40.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  //apply padding horizontal or vertical only
                  child: Text(recipe.text,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
