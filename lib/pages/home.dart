import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '2', name: 'Cyclo', votes: 10),
    Band(id: '3', name: 'Reder', votes: 2),
    Band(id: '4', name: 'Piter', votes: 8),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title:
            const Text('BandsNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, index) => _bandList(bands[index])),
      floatingActionButton: FloatingActionButton(
          onPressed: addNewband,
          elevation: 1,
          child: const Icon(
            Icons.add,
          )),
    );
  }

  Widget _bandList(Band bands) {
    return Dismissible(
      key: Key(bands.id!),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print(' direccion $direction');
        print(bands.id);
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle(color: Colors.white)),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text('${bands.name?.substring(0, 2)}'),
        ),
        title: Text(bands.name!),
        trailing: Text(
          '${bands.votes}',
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () {},
      ),
    );
  }

  addNewband() {
    final textControl = TextEditingController();

    // if (Platform.isAndroid) {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text('Agregar Band'),
    //         content: TextField(
    //           controller: textControl,
    //         ),
    //         actions: [
    //           MaterialButton(
    //               textColor: Colors.blue,
    //               child: const Text('Add'),
    //               onPressed: () => addBandToList(textControl.text)),
    //         ],
    //       );
    //     },
    //   );
    // }

    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text('Agregar Band'),
          content: CupertinoTextField(
            controller: textControl,
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Add'),
              onPressed: () => addBandToList(textControl.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Dismis'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void addBandToList(String name) {
    print(name);
    if (name.length > 1) {
      //podemos agregar
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
