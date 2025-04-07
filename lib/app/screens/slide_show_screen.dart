import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slideshow_app/app/models/media_element.dart';
import 'package:slideshow_app/app/widgets/control_panel.dart';
import '../models/slide.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:ffmpeg_helper/ffmpeg_helper.dart';
import 'package:path/path.dart' as path;

class SlideShowScreen extends StatefulWidget {
  final List<Slide> slides;

  SlideShowScreen({required this.slides});

  @override
  _SlideShowScreenState createState() => _SlideShowScreenState();
}

class _SlideShowScreenState extends State<SlideShowScreen> {
  int _currentSlideIndex = 0;
  int _currentElementIndex = 0;
  double _speed = 1.0;
  bool _isPlaying = false;
  Timer? _timer;

  bool ffmpegPresent = false;
  ValueNotifier<FFMpegProgress> downloadProgress = ValueNotifier<FFMpegProgress>(FFMpegProgress(
    downloaded: 0,
    fileSize: 0,
    phase: FFMpegProgressPhase.inactive,
  ));
  FFMpegHelper ffmpeg = FFMpegHelper.instance;

  Future<void> checkFFMpeg() async {
    bool present = await ffmpeg.isFFMpegPresent();
    ffmpegPresent = present;
    if (present) {
      print('ffmpeg available');
    } else {
      print('ffmpeg needs to setup');
      downloadFFMpeg();
    }
    setState(() {});
  }

  Future<void> downloadFFMpeg() async {
    if (Platform.isWindows) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Downloading FFmpeg'),
            content: ValueListenableBuilder(
              valueListenable: downloadProgress,
              builder: (context, FFMpegProgress progress, child) {
                double? value;
                if (progress.downloaded != 0 && progress.fileSize != 0) {
                  value = progress.downloaded / progress.fileSize;
                } else {
                  value = 0.0;
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(progress.phase.name),
                    SizedBox(height: 5),
                    LinearProgressIndicator(value: value),
                  ],
                );
              },
            ),
          );
        },
      );

      bool success = await ffmpeg.setupFFMpegOnWindows(
        onProgress: (FFMpegProgress progress) {
          downloadProgress.value = progress;
        },
      );

      Navigator.of(context).pop();

      setState(() {
        ffmpegPresent = success;
      });

      if (!success) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('FFmpeg installation failed.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkFFMpeg();
    _startSlideShow();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSlideShow() {
    setState(() {
      _isPlaying = true;
    });
    _showNextElement();
  }

  void _pauseSlideShow() {
    setState(() {
      _isPlaying = false;
    });
  }

  void _showNextElement() {
    if (_isPlaying) {
      final duration = (1000 / _speed).round(); // 1000ms = 1 second
      _timer = Timer(Duration(milliseconds: duration), () {
        setState(() {
          _currentElementIndex++;
          if (_currentElementIndex >= widget.slides[_currentSlideIndex].mediaElements.length) {
            _currentElementIndex = 0;
            _currentSlideIndex = (_currentSlideIndex + 1) % widget.slides.length;
          }
        });
        _showNextElement();
      });
    }
  }

  void _changeSpeed(double newSpeed) {
    setState(() {
      _speed = newSpeed;
    });
  }

  Future<void> createVideoFromImages(List<MediaElement> imageFiles, String outputFilePath) async {
    // Define the output file path on the D drive

    // Get temporary directory
    final tempDir = await getTemporaryDirectory();
    final tempImagePaths = <String>[];

    // Process and save images to temporary directory
    for (var i = 0; i < imageFiles.length; i++) {
      final image = img.decodeImage(File(imageFiles[i].content).readAsBytesSync());
      final tempImagePath = path.join(tempDir.path, 'image_$i.png');
      File(tempImagePath).writeAsBytesSync(img.encodePng(image!));
      tempImagePaths.add(tempImagePath);
    }

    List<String> args = [
      '-r',
      '30',
    ];
    // Create FFMpegCommand for creating a video from images
    final ffmpegCommand = FFMpegCommand(
      inputs: tempImagePaths.map((imagePath) => FFMpegInput.asset(imagePath)).toList(),
      args: [
        const LogLevelArgument(LogLevel.info),
        const OverwriteArgument(),
        CustomArgument(args),
      ],
      outputFilepath: outputFilePath,
    );

    // Run the FFmpeg command
    final ffmpeg = FFMpegHelper();
    await ffmpeg.runSync(
      ffmpegCommand,
      // onComplete: (outputFile) {
      //   print("----------------------done------------------------");
      //   print('Video created at $outputFilePath');
      // },

      statisticsCallback: (statistics) {
        print('bitrate: ${statistics.getBitrate()}');
        print('bitrate: ${statistics.getSize()}');
        print('bitrate: ${statistics.getSpeed()}');
        print('bitrate: ${statistics.getTime()}');
        print('bitrate: ${statistics.getTimeDuration()}');
        print('bitrate: ${statistics.getVideoFps()}');
        print('bitrate: ${statistics.getVideoFrameNumber()}');
      },
    );

    // Print the final output file path
  }

  @override
  Widget build(BuildContext context) {
    final slide = widget.slides[_currentSlideIndex];
    final mediaElement = slide.mediaElements[_currentElementIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Slide Show', style: TextStyle(color: Colors.white))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (mediaElement.type == 'Image')
              Container(
                height: 500,
                width: 700,
                child: Image.file(File(mediaElement.content), fit: BoxFit.fill),
              ),
            if (mediaElement.type == 'Text')
              Text(
                mediaElement.content,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            const SizedBox(height: 150),
            ControlPanel(
              onStart: _startSlideShow,
              onPause: _pauseSlideShow,
              onSpeedChange: _changeSpeed,
              currentSpeed: _speed,
            ),
            ElevatedButton(
              onPressed: () async {
                final outputFilePath = path.join("D:\\Downloads\\New_folder", 'output_video.mp4');
                await createVideoFromImages(slide.mediaElements, outputFilePath).then(
                  (value) {
                    print('Video created at $outputFilePath');
                  },
                );
              },
              child: const Text('download'),
            ),
          ],
        ),
      ),
    );
  }
}
