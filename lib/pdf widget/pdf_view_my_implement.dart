import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';

import '../provider/will_be_required.dart';

class PdfViewMyImplementation extends StatefulWidget {
  final String path;

  PdfViewMyImplementation({required this.path});

  @override
  _PdfViewMyImplementationState createState() =>
      _PdfViewMyImplementationState();
}

class _PdfViewMyImplementationState extends State<PdfViewMyImplementation> {

  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  void deactivate() async{
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    print("deactivated");
    await File(widget.path).delete();
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    super.deactivate();
  }

  @override
  void didUpdateWidget(covariant PdfViewMyImplementation oldWidget) async{
    await File(widget.path).delete();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context){
    String? pdfName =
        Provider.of<WillBeRequired>(context, listen: false).getPdfName();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff5f5f5),
        foregroundColor: Colors.pink,
        centerTitle: true,
        title: Text(
          pdfName == '' ? 'Market Aktüel' : pdfName,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            autoSpacing: false,
            fitEachPage: true,
            pageFling: false,
            pageSnap: false,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false,
            // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
    );
  }
}
