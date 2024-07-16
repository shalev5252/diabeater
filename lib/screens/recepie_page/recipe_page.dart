import 'dart:convert';
import 'package:diabeater/models/Recipe.dart'; //import '../../models/Recipe.dart';
import 'package:diabeater/widgets/nice_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../../models/loading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  String authToken = "";
  Map<String, Recipe> recipeList = new Map();

  late Future<Map<String, Recipe>> myfuture;

  @override
  void initState() {
    super.initState();
    myfuture = getRandomRecipes(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: myfuture,
            builder: (context, AsyncSnapshot<Map<String, Recipe>> snapshot) {
              if (snapshot.hasError)
                return Text(
                    AppLocalizations.of(context)!.error('${snapshot.error}'));
              if (snapshot.hasData) {
                return Scaffold(
                  backgroundColor: Color.fromRGBO(242, 243, 247, 255),
                  body: new SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        for (MapEntry<String, Recipe> recipe
                            in recipeList.entries)
                          NiceCard(
                              recipe.key,
                              recipe.value.recipe_title,
                              recipe.value.recipe_image,
                              recipe.value.recipe_description,
                              recipe.value.author,
                              recipe.value.text,
                              recipe.value.date,
                              5),
                        recipeList.isEmpty
                            ? Center(
                                child: Text(AppLocalizations.of(context)!
                                    .error_occurred))
                            : Container(),
                      ],
                    ),
                  ),
                );
              } else
                return Loading();
            }));
  }

  Future<Map<String, Recipe>> getRandomRecipes(int amount) async {
    String tempToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    setState(() {
      authToken = tempToken;
    });
    Map<String, String> requestHeaders = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': authToken
    };
    final response = await http.get(
        Uri.parse(
            "https://diabeater-backend-master-zhjteefc7q-uc.a.run.app/recipes/random/" +
                amount.toString()),
        headers: requestHeaders);
    setState(() {
      // userGoalList = createGoalList(json.decode(response.body));
      recipeList = createNewRecipeList(json.decode(response.body));
    });
    return recipeList;
  }
}
