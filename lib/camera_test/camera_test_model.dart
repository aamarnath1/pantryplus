import '/flutter_flow/flutter_flow_util.dart';
import 'camera_test_widget.dart' show CameraTestWidget;
import 'package:flutter/material.dart';

class CameraTestModel extends FlutterFlowModel<CameraTestWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
