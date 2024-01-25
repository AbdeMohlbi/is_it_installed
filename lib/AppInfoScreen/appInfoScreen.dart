import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const Color appBarColor = Color(0XFF0B60B0);
const Color scaffoldColor = Color(0XFFF0EDCF);

class DestinationScreen extends StatelessWidget {
  final String? appName;
  final Uint8List? appIcon;
  final String? packageName;
  final String? versionName;
  final int? versionCode;
  DestinationScreen(
      {super.key,
      required this.appName,
      required this.appIcon,
      required this.packageName,
      required this.versionName,
      required this.versionCode});

  final Uri _url = Uri.parse('https://github.com/AbdeMohlbi');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        title: const Text('App Details'),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      primary: true,
      extendBody: true,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 1),
          Image.memory(
            appIcon!,
            height: 50,
            width: 50,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error);
            },
          ),
          Text(appName!,
              style: const TextStyle(
                fontSize: 24.0,
              )),
          const Spacer(flex: 1),
          Text(
            'Package Name: $packageName',
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Version Name: $versionName',
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Version Code: $versionCode',
          ),
          const Spacer(flex: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('made by '),
              GestureDetector(
                onTap: () {
                  _launchUrl();
                },
                child: const Text(
                  'AbdeMohlbi',
                  style: TextStyle(
                    color: Colors.blue, // Set the desired text color here
                    fontSize:
                        24.0, // You can also customize other text properties
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
