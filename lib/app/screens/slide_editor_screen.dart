import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import '../models/slide.dart';
import '../models/media_element.dart';

class SlideEditorScreen extends StatefulWidget {
  final Slide? slide;
  final Function(Slide) onSave;

  SlideEditorScreen({this.slide, required this.onSave});

  @override
  _SlideEditorScreenState createState() => _SlideEditorScreenState();
}

class _SlideEditorScreenState extends State<SlideEditorScreen> {
  final _titleController = TextEditingController();
  // final _durationController = TextEditingController();
  List<MediaElement> _mediaElements = [];

  @override
  void initState() {
    super.initState();
    if (widget.slide != null) {
      _titleController.text = widget.slide!.title;
      // _durationController.text = widget.slide!.duration.inSeconds.toString();
      _mediaElements = widget.slide!.mediaElements;
    }
  }

  void _saveSlide() {
    final title = _titleController.text;
    // final durationText = _durationController.text;
    // if (title.isEmpty || durationText.isEmpty) {
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all fields'),
      ));
      return;
    }

    // final duration = Duration(seconds: int.parse(durationText));

    final slide = Slide(
      id: widget.slide?.id ?? UniqueKey().toString(),
      title: title,
      mediaElements: _mediaElements,
      // duration: duration,
    );

    widget.onSave(slide);
    Navigator.of(context).pop();
  }

  Future<void> _addMediaElement() async {
    final mediaElement = await showDialog<MediaElement>(
      context: context,
      builder: (context) {
        String? selectedType;
        final _contentController = TextEditingController();
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey.shade400,
              title: const Text('Add Media Element'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      hint: const Text("Select"),
                      underline: const SizedBox(),
                      value: selectedType,
                      onChanged: (value) {
                        setState(() {
                          selectedType = value;
                        });
                      },
                      items: ['Image', 'Text']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (selectedType == 'Text')
                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: 'Text',
                        labelStyle: TextStyle(color: Colors.grey.shade700),
                        contentPadding: const EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
                        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
                      ),
                    ),
                  if (selectedType == 'Image')
                    ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.image,
                          allowMultiple: true,
                        );

                        if (result != null) {
                          List<File> files = result.paths.map((path) => File(path!)).toList();
                          setState(() {
                            for (var file in files) {
                              _mediaElements.add(MediaElement(
                                type: 'Image',
                                content: file.path,
                              ));
                            }
                          });

                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Select Images'),
                    ),
                  // if (selectedType == 'Video')
                  //   ElevatedButton(
                  //     onPressed: () async {
                  //       final picker = ImagePicker();
                  //       final pickedFile = await picker.pickVideo(
                  //         source: ImageSource.gallery,
                  //       );
                  //       if (pickedFile != null) {
                  //         final file = File(pickedFile.path);

                  //         setState(() {
                  //           _mediaElements.add(MediaElement(
                  //             type: 'Video',
                  //             content: file.path,
                  //           ));
                  //         });

                  //         Navigator.of(context).pop();
                  //       }
                  //     },
                  //     child: Text('Select Video'),
                  //   ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                ),
                if (selectedType == 'Text')
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(
                        MediaElement(type: selectedType!, content: _contentController.text),
                      );
                    },
                    child: const Text('Add', style: TextStyle(color: Colors.black)),
                  ),
              ],
            );
          },
        );
      },
    );

    if (mediaElement != null) {
      setState(() {
        _mediaElements.add(mediaElement);
      });
    }
  }

  void _removeMediaElement(int index) {
    setState(() {
      _mediaElements.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.slide == null ? 'Add Slide' : 'Edit Slide',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.save, size: 30),
              onPressed: _saveSlide,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
              child: TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.only(left: 10),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
                  disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
            //   child: TextField(
            //     controller: _durationController,
            //     style: const TextStyle(color: Colors.white),
            //     decoration: InputDecoration(
            //       labelText: 'Duration (seconds)',
            //       labelStyle: const TextStyle(color: Colors.grey),
            //       contentPadding: const EdgeInsets.only(left: 10),
            //       border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
            //       enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
            //       focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
            //       disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade700)),
            //     ),
            //     keyboardType: TextInputType.number,
            //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //   ),
            // ),
            // const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,top: 15),
              child: Text(' Media Elements - ', style: TextStyle(color: Colors.grey.shade400, fontSize: 30, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
            ),
            const SizedBox(height: 30),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _mediaElements.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text((index + 1).toString(), style: const TextStyle(color: Colors.white, fontSize: 19)),
                                const SizedBox(width: 20),
                                _mediaElements[index].type == 'Image'
                                    ? Container(height: 200, width: 300, child: Image(image: FileImage(File(_mediaElements[index].content)), fit: BoxFit.fill))
                                    : Text(
                                        _mediaElements[index].content,
                                        style: const TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () => _removeMediaElement(index),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 100)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 30, vertical: 20)),
          ),
          onPressed: () {
            _addMediaElement().then((value) {
              setState(() {});
            });
          },
          child: const Text(
            'Add Media Element',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
