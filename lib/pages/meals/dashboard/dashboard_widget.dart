import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_fresh/auth/firebase_auth/auth_util.dart';
import 'package:keep_fresh/flutter_flow/flutter_flow_widgets.dart';
import 'package:keep_fresh/flutter_flow/nav/nav.dart';
import 'package:keep_fresh/index.dart';
import 'package:keep_fresh/main.dart';
import 'package:provider/provider.dart';

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

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'Dashboard'});
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 0, 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AuthUserStreamWidget(
                        builder: (context) => 
                        Flexible( 
                        child : Text(
                          'Welcome${currentUserDocument != null ?  ', $currentUserDisplayName' : '' }',
                          //  softWrap: true,
                          //  overflow: TextOverflow.ellipsis,
                           style:FlutterFlowTheme.of(context)
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color:Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expiry Calendar',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Comfortaa',
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
                  ),
                ),
                 Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color:Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Grocery List',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Comfortaa',
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
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(30.5, 25, 30.5, 15),
                    child: FFButtonWidget(
                      onPressed: () {
                         Navigator.push(context,
                    MaterialPageRoute(builder: (context) => (const NewPantryWidget()) ));
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
                      )    
                      ),
                  )
                ),
              ],
            ),
            
          ),
        ),
      ),
    );
  }
}
