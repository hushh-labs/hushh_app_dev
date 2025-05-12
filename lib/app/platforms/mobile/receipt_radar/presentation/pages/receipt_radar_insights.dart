// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart';
// import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/insights.dart';
// import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
// import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/ai_insights_widget.dart';
// import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_radar_app_bar.dart';
// import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
// import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';
//
// class ReceiptRadarInsightsArgs {
//   final String uid;
//
//   ReceiptRadarInsightsArgs({required this.uid});
// }
//
// class ReceiptRadarInsights extends StatefulWidget {
//   const ReceiptRadarInsights({super.key});
//
//   @override
//   State<ReceiptRadarInsights> createState() => _ReceiptRadarInsightsState();
// }
//
// class _ReceiptRadarInsightsState extends State<ReceiptRadarInsights> {
//   final controller = sl<ReceiptRadarBloc>();
//
//   ReceiptInsights? get insights => null; //controller.insights;
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       final args = ModalRoute.of(context)!.settings.arguments!
//           as ReceiptRadarInsightsArgs;
//       controller.add(FetchInsightsEvent(args.uid, null));
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const ReceiptRadarAppBar(
//         title: "Receipts Insights",
//       ),
//       body: BlocBuilder(
//           bloc: controller,
//           builder: (context, state) {
//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 16),
//                   if (insights != null)
//                     AiInsightsWidget(
//                       insights: insights!,
//                     ),
//                   const SizedBox(height: 16),
//                   const Padding(
//                     padding: EdgeInsets.only(left: 16.0),
//                     child: Text(
//                       "Scanned Receipts:",
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   const SizedBox(height: 32),
//                 ],
//               ),
//             );
//           }),
//     );
//   }
//
//   void onPreview(String fileType, String url) async {
//     try {
//       ToastManager(Toast(title: 'Opening receipt...')).show(context);
//       var response = await get(Uri.parse(url));
//       var bytes = response.bodyBytes;
//
//       Directory tempDir = await getTemporaryDirectory();
//       String tempPath = tempDir.path;
//
//       String filePath = '$tempPath/${const Uuid().v4()}.pdf';
//       File file = File(filePath);
//       await file.writeAsBytes(bytes);
//
//       await OpenFilex.open(filePath);
//     } catch (e) {
//       if (kDebugMode) {
//       }
//     }
//   }
// }
