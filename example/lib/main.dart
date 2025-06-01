import 'package:flutter/material.dart';
import 'package:gltf_loader/gltf_loader.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'glTF loader example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'glTF loader example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? error;
  GLTF? obj;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(obj?.toString() ?? error ?? 'Load glTF object'),
            Text('', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          TextEditingController controller = TextEditingController();
          String? result = await showAdaptiveDialog<String?>(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return AlertDialog(
                title: Text('glTF url'),
                content: TextField(controller: controller),
                actions: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context, controller.text);
                    },
                    child: Text('Ok'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ],
              );
            },
          );
          if (result != null) {
            String name = basename(result);
            Uri uri = Uri.parse(result);
            var response = await http.get(uri);
            //try {
            obj = await GLTF.loadGLTF(name, response.body, (assetUri) async {
              var response = await http.get(uri.resolve(assetUri!));
              return response.bodyBytes;
            });
            error = null;
            //} catch (e) {
            //  obj = null;
            //  error = e.toString();
            //}
            setState(() {});
          }
        },
        label: Text('Load glTF file'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
