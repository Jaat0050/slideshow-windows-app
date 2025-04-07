// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(title: Text('Interactive Slideshow', style: TextStyle(color: Colors.white))),
//       body: Container(
//         height: height,
//         width: width,
//         padding: EdgeInsets.only(top: 30),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             InkWell(
//               hoverColor: Colors.red,
//               onTap: () {},
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(8)),
//                 child: Text('Add Slides',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
