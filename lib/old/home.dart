// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image/image.dart' as img;
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:slideshow_app/models.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   Slideshow slideshow = Slideshow();
//   Tachistoscope tachistoscope = Tachistoscope();
//   int currentIndex = 0;
//   bool isPlaying = false;
//   Timer? slideshowTimer;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Interactive Slideshow',style: TextStyle(color: Colors.white),),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: loadSlides,
//               child: Text('Load Slides'),
//             ),
//             ElevatedButton(
//               onPressed: isPlaying ? null : startSlideshow,
//               child: Text('Start Slideshow'),
//             ),
//             if (slideshow.slides.isNotEmpty)
//               Image.file(
//                 File(slideshow.slides[currentIndex].imagePath),
//                 width: slideshow.slides[currentIndex].imageWidth.toDouble(),
//                 height: slideshow.slides[currentIndex].imageHeight.toDouble(),
//               ),
//             if (slideshow.slides.isNotEmpty && tachistoscope.showText)
//               Text(slideshow.slides[currentIndex].textContent),
//             ElevatedButton(
//               onPressed: () => convertOutput(slideshow),
//               child: Text('Convert Output'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> loadSlides() async {
//     final List<XFile>? images = await ImagePicker().pickMultiImage();

//     if (images != null) {
//       setState(() {
//         slideshow.slides = images.map((image) {
//           return Slide(
//             imagePath: image.path,
//             textContent: 'Slide',
//             imageWidth: 300, // Set your desired width
//             imageHeight: 300, // Set your desired height
//           );
//         }).toList();
//       });
//     }
//   }

//   void startSlideshow() {
//     setState(() {
//       isPlaying = true;
//     });
//     slideshowTimer = Timer.periodic(
//         Duration(milliseconds: (tachistoscope.presentationDuration / slideshow.playbackSpeed).round()), (timer) {
//       if (currentIndex < slideshow.slides.length - 1) {
//         setState(() {
//           currentIndex++;
//         });
//       } else {
//         if (tachistoscope.repeat) {
//           setState(() {
//             currentIndex = 0;
//           });
//         } else {
//           timer.cancel();
//           setState(() {
//             isPlaying = false;
//           });
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     slideshowTimer?.cancel();
//     super.dispose();
//   }

//   Future<void> convertOutput(Slideshow slideshow) async {
//     // Convert to images
//     await convertToImages(slideshow);

//     // Convert to video clips
//     await convertToVideoClips(slideshow);
//   }

//   Future<void> convertToImages(Slideshow slideshow) async {
//     final directory = await getApplicationDocumentsDirectory();
//     for (int i = 0; i < slideshow.slides.length; i++) {
//       final slide = slideshow.slides[i];
//       final image = img.decodeImage(File(slide.imagePath).readAsBytesSync());
//       final resizedImage = img.copyResize(image!, width: slide.imageWidth, height: slide.imageHeight);
//       final imageFile = File('${directory.path}/slide_$i.png')
//         ..writeAsBytesSync(img.encodePng(resizedImage));
//       print('Saved ${imageFile.path}');
//     }
//   }

//   Future<void> convertToVideoClips(Slideshow slideshow) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final List<String> imagePaths = [];

//     for (int i = 0; i < slideshow.slides.length; i++) {
//       final slide = slideshow.slides[i];
//       final image = img.decodeImage(File(slide.imagePath).readAsBytesSync());
//       final resizedImage = img.copyResize(image!, width: slide.imageWidth, height: slide.imageHeight);
//       final imagePath = '${directory.path}/slide_$i.png';
//       final imageFile = File(imagePath)..writeAsBytesSync(img.encodePng(resizedImage));
//       imagePaths.add(imagePath);
//     }

//     final ffmpeg = FlutterFFmpeg();
//     final outputVideoPath = '${directory.path}/slideshow.mp4';
//     final inputs = imagePaths.map((path) => '-i $path').join(' ');
//     final duration = (1000 / slideshow.playbackSpeed).toInt();
//     final command = '-y $inputs -vf "fps=1/$duration" -pix_fmt yuv420p $outputVideoPath';

//     await ffmpeg.execute(command);
//     print('Video saved at $outputVideoPath');
//   }
// }
