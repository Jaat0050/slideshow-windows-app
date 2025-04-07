


import 'package:flutter/material.dart';
import 'package:slideshow_app/app/widgets/slide_list_items.dart';
import 'slide_editor_screen.dart';
import 'slide_show_screen.dart';
import '../models/slide.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Slide> slides = [];

  void _addSlide() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SlideEditorScreen(
          onSave: (Slide slide) {
            setState(() {
              slides.add(slide);
            });
          },
        ),
      ),
    );
  }

  void _editSlide(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SlideEditorScreen(
          slide: slides[index],
          onSave: (Slide slide) {
            setState(() {
              slides[index] = slide;
            });
          },
        ),
      ),
    );
  }

  void _deleteSlide(int index) {
    setState(() {
      slides.removeAt(index);
    });
  }

  void _startSlideshow(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SlideShowScreen(slides: [slides[index]]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Slideshow', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: slides.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: SlideListItem(
              slide: slides[index],
              onEdit: () => _editSlide(index),
              onDelete: () => _deleteSlide(index),
              onStartSlideshow: () => _startSlideshow(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        tooltip: "Add Slide",
        onPressed: _addSlide,
        child: Icon(Icons.add),
      ),
    );
  }
}
