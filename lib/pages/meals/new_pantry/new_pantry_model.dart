import '/flutter_flow/flutter_flow_util.dart';
import 'new_pantry_widget.dart' show NewPantryWidget;
import 'package:flutter/material.dart';

class NewPantryModel extends FlutterFlowModel<NewPantryWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
