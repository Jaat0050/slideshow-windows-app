// import 'package:flutter/material.dart';
// import 'package:slideshow_app/constants.dart';
// import '../models/slide.dart';

// class SlideListItem extends StatelessWidget {
//   final Slide slide;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;

//   SlideListItem({
//     required this.slide,
//     required this.onEdit,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: ListTile(
//         contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
//         title: Text(slide.title, style: TextStyle(color: Colors.black, fontSize: 20)),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
//             IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import '../models/slide.dart';

class SlideListItem extends StatelessWidget {
  final Slide slide;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onStartSlideshow;

  SlideListItem({
    required this.slide,
    required this.onEdit,
    required this.onDelete,
    required this.onStartSlideshow,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("  ${slide.title}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...slide.mediaElements.map((element) {
                    if (element.type == 'Image') {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Image.file(File(element.content), height: 50, width: 50),
                      );
                    }
                    return Text('');
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onDelete,
                ),
                IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: onStartSlideshow,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
