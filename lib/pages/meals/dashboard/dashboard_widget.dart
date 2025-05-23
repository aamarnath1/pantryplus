import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_fresh/auth/firebase_auth/auth_util.dart';
import 'package:keep_fresh/backend/schema/pantry_data.dart';
import 'package:keep_fresh/backend/schema/food_items.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_widgets.dart';
import 'package:keep_fresh/index.dart';
import 'package:keep_fresh/pages/meals/expiry_calender/expiry_calender_widget.dart';
import 'package:keep_fresh/pages/meals/grocery_list/grocery_list_widget.dart';
import 'package:keep_fresh/pages/meals/recipes/recipes_widget.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'dashboard_model.dart';
export 'dashboard_model.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key,
  this.cameraMap,
 this.camera});

  final CameraDescription? camera;
  final Map<dynamic, Future<CameraDescription>>? cameraMap;
  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}


class _DashboardWidgetState extends State<DashboardWidget> {
  late DashboardModel _model;
  late Future<List<dynamic>> pantryItems;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'Dashboard'});
    pantryItems = getPantryDetails();
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('DASHBOARD_PAGE_Dashboard_ON_INIT_STATE');
      logFirebaseEvent('Dashboard_haptic_feedback');
      HapticFeedback.mediumImpact();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<List> getPantryDetails () async {
    late List pantryData = [];
    try{
    var foodItems = await FoodItemsRecord.getAllRecordsWithUid(currentUserDocument!.uid);
      for(var item in foodItems){
        pantryData.add({
          'displayName': item.displayName,
          'pantryItem': item.pantryItem,
          'pantryItemDetails': item.pantryItemDetails,
          'pantryItemId': item.pantryItemId,
          'imageUrl': item.imageUrl,
          'geminiExpiryDate': item.geminiExpiryDate,
          'updatedExpiryDate': item.updatedExpiryDate,
          'createdTime': item.createdTime,
        });
      }     
      return pantryData;
    } catch (e) {
      print('Error: $e');
    }
    return []; // Add a return statement to ensure a value is always returned.
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
        appBar: AppBar(
          backgroundColor: Color(0xFFEDE8DF),
          automaticallyImplyLeading: false,
          title: Text(
            'Home',
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
            actions: [
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                    child: FlutterFlowIconButton(
                      borderRadius: 20,
                      buttonSize: 40,
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: const Color(0xFF000000),
                        size: 24,
                      ),
                      onPressed: () {
                       Navigator.push(context,
                    MaterialPageRoute(builder: (context) => (CameraTestWidget(widget.cameraMap!, camera: widget.camera!))));
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                    child: FlutterFlowIconButton(
                      borderRadius: 20,
                      buttonSize: 40,
                      icon: Icon(
                        Icons.face,
                        color: const Color(0xFF000000),
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.push(context,
                    MaterialPageRoute(builder: (context) => (const ProfileWidget()) ));
                      },
                    ),
                  ),
                ),
              ],
              centerTitle: true,
              elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              // Fixed Welcome Text
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 16, 0, 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AuthUserStreamWidget(
                      builder: (context) => 
                      Flexible( 
                        child: Text(
                          'Welcome${currentUserDocument != null ?  ', $currentUserDisplayName' : '' }',
                          style: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .override(
                                    fontFamily: 'Comfortaa',
                                    letterSpacing: 0.0,
                                    color: const Color(0xFF101518)
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Scrollable Cards Section
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Expiry Calendar Card
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ExpiryCalendarWidget(isPreview: false,)),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 1, bottom: 1),
                                            child: Container(
                                              child: ExpiryCalendarWidget(isPreview: true,),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.horizontal(
                                                  right: Radius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Grocery List Card

                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GroceryListWidget()),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 155,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top:1,bottom:1),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage('assets/images/grocery_list.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: BorderRadius.horizontal(
                                                  right: Radius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Grocery list',
                                                  style: FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontFamily: 'Comfortaa',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 17,
                                                        letterSpacing: 0.0,
                                                        color: const Color(0xFF101518),
                                                        useGoogleFonts: GoogleFonts.asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(context)
                                                                    .titleMediumFamily),
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Recipes Card
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RecipesWidget()),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 155,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Recipes',
                                                  style: FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .override(
                                                        fontFamily: 'Comfortaa',
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 17,
                                                        letterSpacing: 0.0,
                                                        color: const Color(0xFF101518),
                                                        useGoogleFonts: GoogleFonts.asMap()
                                                            .containsKey(
                                                                FlutterFlowTheme.of(context)
                                                                    .titleMediumFamily),
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top:1,bottom:1),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage('assets/images/recipe.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: BorderRadius.horizontal(
                                                  right: Radius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Fixed Pantry Button
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(30.5, 25, 30.5, 15),
                child: FFButtonWidget(
                  onPressed: () {
                    pantryItems = getPantryDetails();
                    var pantryData = pantryItems;
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => (NewPantryWidget(pantryItems:pantryData))));
                  },
                  text: 'Pantry +',
                  options: FFButtonOptions(
                    width: 332,
                    height: 50,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: FlutterFlowTheme.of(context).secondary,
                    textStyle:
                        FlutterFlowTheme.of(context).displaySmall.override(
                              fontFamily: FlutterFlowTheme.of(context)
                                  .displaySmallFamily,
                              color: Color.fromARGB(255, 235, 229, 217),
                              letterSpacing: 0,
                              useGoogleFonts: GoogleFonts.asMap()
                                  .containsKey(FlutterFlowTheme.of(context)
                                      .displaySmallFamily),
                            ),
                    elevation: 3,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
