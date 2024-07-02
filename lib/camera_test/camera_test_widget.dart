import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_test_model.dart';
export 'camera_test_model.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'camera_screen.dart';

class CameraTestWidget extends StatefulWidget {

  // final List<CameraDescription> camera;

  final CameraDescription camera;
  CameraTestWidget(Map<dynamic, Future<CameraDescription>> map, {
    super.key,required this.camera,
  });
  @override
  State<CameraTestWidget> createState() => _CameraTestWidgetState();
}

class _CameraTestWidgetState extends State<CameraTestWidget> {
  late CameraTestModel _model;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  // late List<CameraDescription> _cameras;

  final scaffoldKey = GlobalKey<ScaffoldState>();

    File ? _selectedImage;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CameraTestModel());
    _controller = CameraController(
      widget.camera,
       ResolutionPreset.high);
    _controller.initialize().then((_) {
                      if (!mounted) {
                        return;
                      }
                      setState(() {});
                    }).catchError((Object e) {
                      if (e is CameraException) {
                        switch (e.code) {
                          case 'CameraAccessDenied':
                            // Handle access errors here.
                            break;
                          default:
                            // Handle other errors here.
                            break;
                        }
                      }
                    });
    _initializeControllerFuture = _controller.initialize();

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'Camera_test'});
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> openScanner() async {
    String barcodeScanRes;
    try{
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE,);
    debugPrint(barcodeScanRes);
    } on PlatformException {
         barcodeScanRes = 'Failed to get platform version.';
    }
    if(!mounted) return;
    setState(() async {
       var _scanBarcodeResult = barcodeScanRes;
       print('scanned barcode image $_scanBarcodeResult');
      //  var api_key='AIzaSyDR10buQg0OGxbouf1nFhOLGviOy-Da3a4';

      //For US CENTRAL FOOD
      //  var api_key='gPTBA7bVIaFjUm6WXxe77G1QLLHBxQD3YKdnj4zp';
      // var url = 'https://api.nal.usda.gov/fdc/v1/food/$_scanBarcodeResult&api_key=$api_key';

      // nutritionix api
      var url = 'https://trackapi.nutritionix.com/v2/search/item/?upc=$_scanBarcodeResult';

      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'x-app-id': 'c8aeece3',
        'x-app-key': '4d4127a05b466e2f0817270c495c1ef4',
      };
      try {
    var response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      print('response from the api ${response.body}');
      var data = json.decode(response.body);
      print('data obtained from scanned barcode $data');
      // if (data['totalItems'] > 0) {
      //   var book = data['items'][0]['volumeInfo'];
      //   print('Title: ${book['title']}');
      //   print('Authors: ${book['authors'].join(", ")}');
      //   print('Published Date: ${book['publishedDate']}');
      //   // You can extract other details in a similar way...
      // } else {
      //   print('No books found for that ISBN.');
      // }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
    });
  }

  Future<void> pickImageGallery() async {

    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFEDE8DF),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                child: Text(
                  'Take a Picture',
                  style: FlutterFlowTheme.of(context)
                                .headlineMedium
                                .override(
                                  fontFamily: 'Comfortaa',
                                  letterSpacing: 0,
                                  color: const Color(0xFF000000),
                                  useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey('Comfortaa'),   
                                ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Text(
                  'Select the Camera button using AI to find your item\n',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: FFButtonWidget(
                  onPressed: openScanner,
                  text: 'Scan barcode',
                  options: FFButtonOptions(
                    width: 200.0,
                    height: 60.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Inter',
                              color: Colors.white,
                              letterSpacing: 0.0,
                            ),
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                child: Text(
                  'Select the barcode button to scan barcode!\n',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CameraScreen(camera: widget.camera)));
                  },
                  text: 'Open Camera',
                  options: FFButtonOptions(
                    width: 200.0,
                    height: 60.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconPadding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                              fontFamily: 'Inter',
                              color: Colors.white,
                              letterSpacing: 0.0,
                            ),
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            //  _selectedImage != null ? Image.file(_selectedImage!) : const Text("Please select an Image")
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
