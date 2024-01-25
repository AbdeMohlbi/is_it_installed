import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

import 'AppInfoScreen/appInfoScreen.dart';

enum FetchState {
  loading,
  success,
  error,
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'is_it_installed',
      theme: ThemeData(hintColor: Colors.yellow),
      home: const AllAppsScreen(),
    );
  }
}

const Color appBarColor = Color(0XFF0B60B0);
const Color scaffoldColor = Color(0XFFF0EDCF);

class AllAppsScreen extends StatefulWidget {
  const AllAppsScreen({super.key});

  @override
  AllAppsScreenState createState() => AllAppsScreenState();
}

class AllAppsScreenState extends State<AllAppsScreen> {
  late List<AppInfo> currentAppsList = [];
  late List<AppInfo> oldAppList = [];
  FetchState state = FetchState.loading;
  Future<void> fetchApps() async {
    try {
      List<AppInfo> fetchedApps =
          await InstalledApps.getInstalledApps(true, true, "");

      currentAppsList = fetchedApps;
      oldAppList = currentAppsList;
      setState(() {
        state = FetchState.success;
      });
    } catch (e) {
      state = FetchState.error;
    }
  }

  void filterData(String filter) async {
    await Future.delayed(const Duration(seconds: 0), () {});
    setState(() {
      state = FetchState.loading;
    });
    try {
      currentAppsList = oldAppList;
      List<AppInfo> filteredApps =
          currentAppsList.where((app) => app.name!.contains(filter)).toList();

      currentAppsList = filteredApps;

      await Future.delayed(const Duration(seconds: 0), () {});
      setState(() {
        state = FetchState.success;
      });
    } catch (e) {
      setState(() {
        state = FetchState.error;
      });
    }
  }

  @override
  void initState() {
    fetchApps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Intalled apps "),
        centerTitle: true,
      ),
      backgroundColor: scaffoldColor,
      body: switch (state) {
        FetchState.error => const Center(child: Text("no apps found")),
        FetchState.loading => const Center(
              child: CircularProgressIndicator(
            color: appBarColor,
          )),
        _ => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(25, 118, 218, 1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(25, 118, 218, 1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromRGBO(25, 118, 218, 1)),
                    ),
                    label: Text('Search for the app by name'),
                    prefixIcon: Icon(Icons.search_sharp, color: appBarColor),
                    labelStyle: TextStyle(
                      color: appBarColor,
                    ),
                  ),
                  onChanged: (value) {
                    filterData(value);
                  },
                ),
              ),
              Text(" a total of ${currentAppsList.length} app installed  "),
              Expanded(
                child: ListView.builder(
                  itemCount: currentAppsList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(PageAnimationTransition(
                            page: DestinationScreen(
                              appName: currentAppsList[index].name!,
                              appIcon: currentAppsList[index].icon!,
                              packageName: currentAppsList[index].packageName,
                              versionCode: currentAppsList[index].versionCode,
                              versionName: currentAppsList[index].packageName,
                            ),
                            pageAnimationType: RightToLeftTransition()));
                      },
                      child: ListTile(
                        leading: Image.memory(
                          currentAppsList[index].icon!,
                          height: 40,
                          width: 40,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                        title:
                            Text(currentAppsList[index].name ?? 'Unknown App'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
      },
    );
  }
}
