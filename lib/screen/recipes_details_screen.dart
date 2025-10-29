import 'package:final_project_pantrypal/domain/custom_text_style.dart';
import 'package:flutter/material.dart';

class RecipesDetailsScreen extends StatefulWidget {
  String imageSrc;
  String title;
  String cookTime;
  String prepTime;
  String rating;
  String calories;
  String revCount;
  String foodType;
  String difficultLevel;

  RecipesDetailsScreen({
    super.key,
    required this.imageSrc,
    required this.title,
    required this.calories,
    required this.cookTime,
    required this.difficultLevel,
    required this.foodType,
    required this.prepTime,
    required this.rating,
    required this.revCount,
  });

  @override
  State<RecipesDetailsScreen> createState() => _RecipesDetailsScreenState();
}

class _RecipesDetailsScreenState extends State<RecipesDetailsScreen> {
  MediaQueryData? myData;

  @override
  Widget build(BuildContext context) {
    myData = MediaQuery.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Image.network(widget.imageSrc),

          Positioned(
            top: 35,
            left: 9,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                backgroundColor: Colors.orangeAccent.shade200,
                foregroundColor: Colors.brown,

                child: const Icon(Icons.arrow_back_ios_rounded, size: 30),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: myData!.size.height * 0.60,
              width: myData!.size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black87, blurRadius: 7)],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    SizedBox(
                      width: myData!.size.width,
                      height: 100,
                      child: Stack(
                        children: [
                          Text(
                            widget.title,
                            style: myTextStyle24(textWeight: FontWeight.bold),
                          ),
                          Positioned(
                            right: 10,
                              top: 30,
                              child: Image.asset("assets/icons/heart.png", height : 40 , width: 40, )),

                        ],
                      ),
                    ),

                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black12
                          ),
                          child: Column(
                            children: [
                              Image.asset("assets/icons/whisk.png" , height: 60,)
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
