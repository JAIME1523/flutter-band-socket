import 'package:band_names/services/socket_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/band.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    // Band(id: '1', name: 'Metalica', votes: 5),
    // Band(id: '2', name: 'Cyclo', votes: 10),
    // Band(id: '3', name: 'Reder', votes: 2),
    // Band(id: '4', name: 'Piter', votes: 8),
  ];

  @override
  void initState() {
    final serviceSocket = Provider.of<SocketService>(context, listen: false);

    serviceSocket.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final serviceSocket = Provider.of<SocketService>(context, listen: false);
    serviceSocket.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serviceSocket = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title:
            const Text('BandsNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: serviceSocket.serverStatus == ServerStatus.Online
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue[300],
                  )
                : const Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: Column(
        children: [
          _showGrafica(),
          Expanded(
            child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (context, index) => _bandList(bands[index])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: addNewband,
          elevation: 1,
          child: const Icon(
            Icons.add,
          )),
    );
  }

  Widget _bandList(Band band) {
    final serviceSocket = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id!),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) =>
          // print(band.id);

          //emitit
          // delet-band "id":id;
          serviceSocket.socket.emit('delete-band', {
        'id': band.id,
      }),
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
          child: Text('${band.name?.substring(0, 2)}'),
        ),
        title: Text(band.name!),
        trailing: Text(
          '${band.votes}',
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () => serviceSocket.socket.emit('vote-band', {
          'id': band.id,
        }),
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
      builder: (_) => CupertinoAlertDialog(
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
      ),
    );
  }

  void addBandToList(String name) {
    final serviceSocket = Provider.of<SocketService>(context, listen: false);

    if (name.length > 1) {
      //podemos agregar
      //emitir add-band

      //{name: name}
      serviceSocket.socket.emit('add-band', {
        'name': name,
      });
    }
    Navigator.pop(context);
  }

  Widget _showGrafica() {
    Map<String, double> dataMap = {};

    //   = {
    //   "Flutter": 1,
    //   "React": 1,
    //   "Xamarin": 1,
    //   "Ionic": 1,
    // };

    for (var element in bands) {
      dataMap.putIfAbsent(element.name!, () => element.votes.toDouble());

      // print(element.votes.toDouble());
    }

    print('elemento $dataMap');

    // return Container();

    return dataMap.isEmpty ? Container() : PieChart(
      chartType: ChartType.ring,
      dataMap: dataMap);
  }
}
