import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_fresh/camera_test/result_screen.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camera_test_model.dart';
export 'camera_test_model.dart';
// import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
// import 'package:image_picker/image_picker.dart';
import 'camera_screen.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  // late List<CameraDescription> _cameras;

  final scaffoldKey = GlobalKey<ScaffoldState>();

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
    String _barcodeScanRes;
    try{
      final barcodeScanRes = await BarcodeScanner.scan(); 
        _barcodeScanRes = barcodeScanRes.rawContent;
    } on PlatformException {
         _barcodeScanRes = 'Failed to get platform version.';
    }
    if(!mounted) return;
    setState(() async {
       var _scanBarcodeResult = _barcodeScanRes;
       await getProduct(_scanBarcodeResult).then((val) async => {
                if(val.containsKey('error')){
                  Fluttertoast.showToast(
                      msg: "Product not found! Please try different barcode!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  )
                }
       });
 
    });
  }

  Future<Map<String, Object?>> getProduct(barcode) async {
  final navigator = Navigator.of(context);

  OpenFoodAPIConfiguration.userAgent = UserAgent(name:'pantryPlus', version:'1.0.0');

  final ProductQueryConfiguration configuration = ProductQueryConfiguration(
    barcode,
    language: OpenFoodFactsLanguage.ENGLISH,
    fields: [ProductField.ALL],
    version: ProductQueryVersion.v3,
  );
  try{
  final ProductResultV3 result =
      await OpenFoodAPIClient.getProductV3(configuration);

  if (result.status == ProductResultV3.statusSuccess) {

  var productData = {
    "productName": result.product?.productName,
    "brand": result.product?.brands,
    "nutriments": result.product?.nutriments?.getValue(Nutrient.salt, PerSize.oneHundredGrams),
    "additives": result.product?.additives?.names,
    "allergens": result.product?.allergens?.names,
    "ingredients": result.product?.ingredientsText,
    "countries": result.product?.countries,
    "noNutritionData": result.product?.noNutritionData,
    "nutriScore": result.product?.nutriscore,
    "imageUrl": result.product?.imageFrontUrl
  };

                  if(productData.containsKey('productName')){
                          await navigator.push(
                        MaterialPageRoute(
                            builder: (context) => ResultScreen(productData: productData),
                        ),
                      );
                    }
  return productData;
  }else {
    throw Exception('Product not found, please try a different barcode!');
  }
  }catch(e){
    return {'error': e};
}
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
                    dispose();
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
