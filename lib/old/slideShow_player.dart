// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:slideshow_app/models.dart';

// class SlideshowPlayer extends StatefulWidget {
//   final List<Slide> slides;
//   final Tachistoscope tachistoscope;
//   final double playbackSpeed;

//   SlideshowPlayer({
//     required this.slides,
//     required this.tachistoscope,
//     required this.playbackSpeed,
//   });

//   @override
//   _SlideshowPlayerState createState() => _SlideshowPlayerState();
// }

// class _SlideshowPlayerState extends State<SlideshowPlayer> {
//   int currentIndex = 0;
//   late List<Slide> slides;

//   @override
//   void initState() {
//     super.initState();
//     slides = widget.tachistoscope.shuffleSlides
//         ? (widget.slides..shuffle())
//         : widget.slides;
//     startSlideshow();
//   }

//   void startSlideshow() async {
//     while (currentIndex < slides.length) {
//       setState(() {
//         currentIndex++;
//       });
//       await Future.delayed(Duration(
//           milliseconds: (widget.tachistoscope.presentationDuration / widget.playbackSpeed).toInt()));
//       if (widget.tachistoscope.repeat && currentIndex == slides.length) {
//         setState(() {
//           currentIndex = 0;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (currentIndex >= slides.length) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Slideshow Finished'),
//         ),
//         body: Center(
//           child: Text('The slideshow has finished.'),
//         ),
//       );
//     }

//     Slide currentSlide = slides[currentIndex];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Slideshow Player'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.file(
//               File(currentSlide.imagePath),
//               width: currentSlide.imageWidth,
//               height: currentSlide.imageHeight,
//             ),
//             if (widget.tachistoscope.showText)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(currentSlide.textContent),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
