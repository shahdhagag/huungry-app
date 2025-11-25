import 'package:flutter/material.dart';

class ToppingCard extends StatelessWidget {
  final String imageUrl ;
  final String title;
  final VoidCallback onAdd;
  final Color color;

  const ToppingCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.onAdd,
     required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,

      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),


          child: Container(
            height: 85,
            width: 130,
           color: Color(0xff3C2F2F),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [





              ],
            ),
          ),

        ),
           ///image section
        Positioned(
          top: -40,
          right: -5,
          left: -5,
          child: SizedBox(
            height: 80,
            width: 70,
            child: Card(
              color: color,
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          ),
        ),


        //bottom widget

        Positioned(
          right: 0,
          left: 0,
          bottom: 0,


          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,


                  ),
                ),
                
                GestureDetector(
                  onTap: onAdd,
                  child: const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.add, color: Colors.white,size: 15,),
                  ),
                )
          
              ],
            ),
          ),
        )

      ],
    );
  }
}
