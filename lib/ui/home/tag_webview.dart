import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TagWebView extends StatefulWidget {
  final String name;
  final String url;
  TagWebView({required this.name, required this.url});

  @override
  _TagWebViewState createState() => _TagWebViewState();
}

class _TagWebViewState extends State<TagWebView> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : WebView(
              initialUrl: widget.url,
              onWebViewCreated: (controller) {
                print('created');
                setState(() {
                  loading = false;
                });
              },
              onPageStarted: (url) {
                print('starting');
                setState(() {
                  loading = false;
                });
              },
              onPageFinished: (url) {
                print('finished');
                setState(() {
                  loading = false;
                });
              },
            ),
    );
  }
}
