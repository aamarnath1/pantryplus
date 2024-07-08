import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:keep_fresh/camera_test/result_screen.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_util.dart';


class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  CameraScreen({required this.camera});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late final GenerativeModel _model;
  bool _isLoader = false;
  // final _textRecognizer = TextRecognizer();
  bool _isFlashOn = false;
int _selectedCameraIdx = 0;
  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      // apiKey: const String.fromEnvironment('api_key')
      apiKey: 'AIzaSyAQcK7SrU3qP7znukuW5RapadrnGuscHlc'
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    // _textRecognizer.close();
    super.dispose();
  }
   void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    _controller.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  void _switchCamera() {
    setState(() {
      List<CameraDescription> cameras = [];
      _selectedCameraIdx = (_selectedCameraIdx + 1) % cameras.length.toInt();
    });
  }


  void _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: image.path),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                // backgroundColor: AppColors.deepBlue,
                leading: BackButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                centerTitle: true,
                title: Text(
                  'Take a picture',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(
                    icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
                    color: Colors.white,
                    onPressed: _toggleFlash,
                  ),
                ],
              ),
              body: Stack(
                children: <Widget>[
                  CameraPreview(_controller),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: FloatingActionButton(
                        onPressed: _scanImage,
                        child: Icon(Icons.camera_alt_outlined),
                        backgroundColor: Colors.white,
                        // foregroundColor: AppColors.deepBlue,
                      ),
                    ),
                  ),
                  if (_isLoader) // Conditional rendering of the loader
                      Center(
                        child: CircularProgressIndicator(), // Loader
                      ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
Future<void> _scanImage() async{
  if(_controller == null) return;

  final navigator = Navigator.of(context);

  try{
    setState(() {
      _isLoader = true;
    });
    final picturefile = await _controller!.takePicture();
    final file = File(picturefile.path);
    final imageBytes = await file.readAsBytes();
    final prompt = TextPart("You are a grocery analysis bot who is capable of processing images of grocery items and detailed receipts. You should first identify all items in the image or text and categorize them into 'food' and 'non-food' categories. For food items, you should estimate expiry dates based on product type and purchase date  if not specified consider date of image captured, retrieve and display nutritional information, and suggest recipes that incorporate these ingredients. Each food item should also have a concise summary provided, detailing key nutritional facts and storage recommendations. You should ignore non-food items completely and not perform any analysis on them. Employ convolutional neural networks for image recognition, optical character recognition for processing receipt texts, and integrate a database for fetching food-related data. Ensure your output includes actionable insights and is presented in an easy-to-understand format suitable for end-users. Your response is diplayed on html screen provide your response in html format as if you are writing the code inside a div tag, every response should be in html format and all the text should be black color and do not include ```html in the response striclty.");
    final imageParts = [DataPart('image/jpeg', imageBytes)];
    final response = await _model.generateContent([
      Content.multi([prompt, ...imageParts])
    ]);
    if(response.text != null){
      setState(() {
        _isLoader = false;
      });
    }

    await navigator.push(
        MaterialPageRoute(
            builder: (context) => ResultScreen(text: response.text ?? '', imagePath: picturefile.path),
        ),
      );

    //TODO For stream data need to be resolved later......
    // final response = await _model.generateContentStream([
    //   Content.multi([prompt, ...imageParts])
    // ]);
    // await for(final chunk in response){
    //   print('chunk: ${chunk.text}');
    //   await navigator.push(
    //     MaterialPageRoute(
    //       // builder: (context) => ResultScreen(text: recognizedText.text),
    //         builder: (context) => ResultScreen(text: chunk.text ?? ''),
    //     ),
    //   );
    // }
    // final inputImage = InputImage.fromFilePath(file.path);
    // print('imagepath ${file.path}');
    // final recognizedText = await _textRecognizer.processImage(inputImage);
    // print('recognizedText: ${recognizedText.text}');

  }catch(e){
    print('error scanning image: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error scanning image")));
  }
}
}


class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  DisplayPictureScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // ...

      body: Image.file(File(imagePath)),
    );
  }
}
