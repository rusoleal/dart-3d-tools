import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gltf_loader/gltf.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'glTF loader example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
            Uri uri = Uri.parse(result);
            var response = await http.get(uri);
            //try {
            obj = await GLTF.loadGLTF(response.body, (assetUri) async {
              print('Loading asset: $assetUri');
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
