import 'package:slideshow_app/app/models/media_element.dart';

class Slide {
  String id;
  String title;
  List<MediaElement> mediaElements;
  // Duration duration;

  Slide({
    required this.id,
    required this.title,
    required this.mediaElements,
    // required this.duration,
  });
}