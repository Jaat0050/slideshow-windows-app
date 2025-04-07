class MediaElement {
  String type; // "image", "text", "video"
  dynamic content; // URL or text content

  MediaElement({
    required this.type,
    required this.content,
  });
}