import '/components/accordion_section/accordion_section_widget.dart';
import '/components/custom_appbar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'support_center_widget.dart' show SupportCenterWidget;
import 'package:flutter/material.dart';

class SupportCenterModel extends FlutterFlowModel<SupportCenterWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for customAppbar component.
  late CustomAppbarModel customAppbarModel;
  // Model for accordionSection component.
  late AccordionSectionModel accordionSectionModel;

  @override
  void initState(BuildContext context) {
    customAppbarModel = createModel(context, () => CustomAppbarModel());
    accordionSectionModel = createModel(context, () => AccordionSectionModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    customAppbarModel.dispose();
    accordionSectionModel.dispose();
  }
}
