import 'dart:async';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scene3d/project.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  Project? _project;

  @override
  void initState() {
    super.initState();

    /*Uri helmet = Uri.parse('https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Assets/main/Models/DamagedHelmet/glTF/DamagedHelmet.gltf');
    http.get(helmet).then((response) async {
      if (response.statusCode == 200) {
        _project = await Project.loadGLTF(response.body, (uri) async {
          //print(helmet.toString());
          //String absoluteUri = relative(uri,from: helmet.toString());
          //print(absoluteUri);
          Uri bufferUri = helmet.resolve(uri);
          print(bufferUri);
          var response = await http.get(bufferUri);
          print('uri: $uri length: ${response.bodyBytes.length}');
          return response.bodyBytes;
        },);
      }
      setState(() {});
    },);*/
  }

  @override
  Widget build(BuildContext context) {

    String text = 'Loading asset...';
    if (_project != null) {
      text = 'Buffers: ${_project!.buffers.length}\n'
          'BufferViews: ${_project!.bufferViews.length}\n'
          'Accessors: ${_project!.accessors.length}\n'
          'Samplers: ${_project!.samplers.length}\n';
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child:MenuBar(children: MenuEntry.build(_getMenus()),))
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ]
                  ),
                  child: _getLateralMenu()
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(text),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getLateralMenu() {
    if (_project == null) {
      return Container();
    }
    return ListView(
      padding: EdgeInsets.all(12),
      itemExtent: 30,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Accessors:'),Text('${_project!.accessors.length}')],),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Animations:'),Text('${_project!.animations.length}')],),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Buffers:'),Text('${_project!.buffers.length}')],),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('BufferViews:'),Text('${_project!.bufferViews.length}')],),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Cameras:'),Text('${_project!.cameras.length}')],),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Images:'),Text('${_project!.images.length}')],),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Materials:'),Text('${_project!.materials.length}')],),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Meshes:'),Text('${_project!.meshes.length}')],),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Nodes:'),Text('${_project!.nodes.length}')],),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Samplers:'),Text('${_project!.samplers.length}')],),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Scenes:'),Text('${_project!.scenes.length}')],),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Skins:'),Text('${_project!.skins.length}')],),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Textures:'),Text('${_project!.textures.length}')],),
      ],
    );
  }

  List<MenuEntry> _getMenus() {
    final List<MenuEntry> result = <MenuEntry>[
      MenuEntry(
        label: 'File',
        menuChildren: <MenuEntry>[
          MenuEntry(
            label: 'Load from URL...',
            onPressed: () async {
              TextEditingController controller = TextEditingController();
              String? url = await showAdaptiveDialog<String?>(context: this.context, builder: (context) {
                return AlertDialog(
                  title: Text('Load from URL'),
                  content: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'URL',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context,null);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context,controller.text);
                      },
                      child: Text('Ok'),
                    )
                  ],
                );
              },);
              if (url != null) {
                var projectUri = Uri.parse(url);
                var response = await http.get(projectUri);
                if (response.statusCode == 200) {
                  _project = await Project.loadGLTF(response.body, (uri) async {
                    //print(helmet.toString());
                    //String absoluteUri = relative(uri,from: helmet.toString());
                    //print(absoluteUri);
                    Uri bufferUri = projectUri.resolve(uri);
                    print(bufferUri);
                    var response = await http.get(bufferUri);
                    print('uri: $uri length: ${response.bodyBytes.length}');
                    return response.bodyBytes;
                  },);
                  setState(() {});
                }
              }
            },
          ),
          MenuEntry(
            label: 'Load from file...',
            onPressed: () {
            },
          ),
        ]
      )
    ];
    return result;
  }

}

class MenuEntry {
  const MenuEntry({required this.label, this.shortcut, this.onPressed, this.menuChildren})
      : assert(
  menuChildren == null || onPressed == null,
  'onPressed is ignored if menuChildren are provided',
  );
  final String label;

  final MenuSerializableShortcut? shortcut;
  final VoidCallback? onPressed;
  final List<MenuEntry>? menuChildren;

  static List<Widget> build(List<MenuEntry> selections) {
    Widget buildSelection(MenuEntry selection) {
      if (selection.menuChildren != null) {
        return SubmenuButton(
          menuChildren: MenuEntry.build(selection.menuChildren!),
          child: Text(selection.label),
        );
      }
      return MenuItemButton(
        shortcut: selection.shortcut,
        onPressed: selection.onPressed,
        child: Text(selection.label),
      );
    }

    return selections.map<Widget>(buildSelection).toList();
  }

  static Map<MenuSerializableShortcut, Intent> shortcuts(List<MenuEntry> selections) {
    final Map<MenuSerializableShortcut, Intent> result = <MenuSerializableShortcut, Intent>{};
    for (final MenuEntry selection in selections) {
      if (selection.menuChildren != null) {
        result.addAll(MenuEntry.shortcuts(selection.menuChildren!));
      } else {
        if (selection.shortcut != null && selection.onPressed != null) {
          result[selection.shortcut!] = VoidCallbackIntent(selection.onPressed!);
        }
      }
    }
    return result;
  }
}
