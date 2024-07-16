class Recipe {
  final String id;
  final String recipe_title;
  final String recipe_description;
  final String recipe_image; //URL

  //maybe those after should be final
  String author;
  String text; //the body of the recipe
  String date; //last_updated

  bool entered;


  //List<String> steps;
  //List<String> ingredients;
  //List<Nutrients> nutrients;

  Recipe(
      { required this.id, required this.recipe_title, required this.recipe_description, required this.recipe_image,
        required this.author, required this.text, required this.date, this.entered = false});

  void recipe_entered(bool val, String newAuthor, String newText, String newDate){
    //the recipe was clicked by the user who checked for more details.
    if (entered != null) {
      this.entered = val;
      this.author = newAuthor;
      this.text = newText;
      this.date = newDate;
    }
    else {
      this.entered = val;
      this.author = newAuthor;
      this.text = newText;
      this.date = newDate;
    }
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': recipe_title,
      'description': recipe_description,
      'image': recipe_image,
      'author': author,
      'text': text,
      'date': date,
      //'entered': entered,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    if (json['date'] == null) {
      json['date'] = "";
    };
    if(json['id'] == null)
      {
        json['id'] = "";
      }
    return Recipe(
      id: json['id'] as String,
      recipe_title: json['title'] as String,
      recipe_description: json['description'] as String,
      recipe_image: json['image'] as String,
      author: json['author'] as String,
      text: json['text'] as String,
      date: json['date'] as String,
      //entered: json['entered'] as bool,
    );
  }
}






String ridfromJson(Map<String, dynamic> json) {
  return json['rid'] as String;
}

List<Recipe> createGoalList(List<dynamic> recipeList){
  List<Recipe> myRecipes = [];
  myRecipes = recipeList.map<Recipe>((json) => Recipe.fromJson(json["data"])).toList();
  return myRecipes;
}

Map<String,Recipe> createNewRecipeList(List<dynamic> recipeList){
  Map<String,Recipe> recipe_dictionary = new Map();
  for (Map<String, dynamic> json in recipeList){
    String key = ridfromJson(json);
    Recipe value = Recipe.fromJson(json["data"]);
    recipe_dictionary.putIfAbsent(key, () => value);

  }
  return recipe_dictionary;
}
