import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PdfViewerPage extends StatefulWidget {
  static const String pageName = '/pdf-viewer';
  const PdfViewerPage({super.key});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {

  String? title;
  String? path;
  
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PdfViewerController pdfViewerController = PdfViewerController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      path = (ModalRoute.of(context)!.settings.arguments as List)[0];
      title = (ModalRoute.of(context)!.settings.arguments as List)[1];

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print(path);
    print("path111");
    return directionality(
      child: Scaffold(

        appBar: appbar(title: title ?? ''),

        // body: DownloadAndOpenPdf(path ?? '')

        // PDFScreen(path: "https://abdulrahman.anmka.com/store/1050/Assignment 2 - General Chemistry 1 - CHM1101.pdf",),

        body: path != null
          ? SfPdfViewer.network(
          path ?? "https://abdulrahman.anmka.com/store/1050/Assignment 2 - General Chemistry 1 - CHM1101.pdf",
              key: _pdfViewerKey,
              controller: pdfViewerController,

            )
          : const SizedBox(),

      )
    );
  }

  @override
  void dispose() {
    pdfViewerController.dispose();
    super.dispose();
  }

}


class DownloadAndOpenPdf extends StatefulWidget {
  final String pdfUrl;
  DownloadAndOpenPdf(this.pdfUrl);
  @override
  _DownloadAndOpenPdfState createState() => _DownloadAndOpenPdfState();
}

class _DownloadAndOpenPdfState extends State<DownloadAndOpenPdf> {

      // "https://abdulrahman.anmka.com/store/1050/Assignment 2 - General Chemistry 1 - CHM1101.pdf";

  String? localPath;

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<void> downloadPdf() async {
    if (await requestStoragePermission()) {
      try {
        final directory = await getExternalStorageDirectory();
        String savePath = "${directory!.path}/assignment.pdf";

        var dio = Dio();
        await dio.download(widget.pdfUrl, savePath);
        print("File downloaded to: $savePath");

        setState(() {
          localPath = savePath;
        });

        // عرض ملف PDF بعد التنزيل
        openPdfViewer(context, savePath);
      } catch (e) {
        print("Error downloading file: $e");
      }
    } else {
      print("Storage permission denied.");
    }
  }

  void openPdfViewer(BuildContext context, String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text("PDF Viewer")),
          body: SfPdfViewer.file(File(filePath)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Download and Open PDF"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await downloadPdf();
          },
          child: Text("Download and Open PDF"),
        ),
      ),
    );
  }
}
