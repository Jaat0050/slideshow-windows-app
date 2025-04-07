// import 'package:flutter/material.dart';
// import '../models/media_element.dart';

// class MediaElementWidget extends StatelessWidget {
//   final MediaElement mediaElement;

//   MediaElementWidget({required this.mediaElement});

//   @override
//   Widget build(BuildContext context) {
//     switch (mediaElement.type) {
//       case 'image':
//         return Container(
//           color: Colors.black,
//           child: Center(
//             child: Icon(Icons.image, color: Colors.white),
//           ),
//         );
//       case 'text':
//         return Text(mediaElement.content, style: TextStyle(fontSize: 16));
//       case 'video':
//         // Placeholder for video widget
//         return Container(
//           color: Colors.black,
//           child: Center(
//             child: Icon(Icons.videocam, color: Colors.white),
//           ),
//         );
//       default:
//         return Container();
//     }
//   }
// }
