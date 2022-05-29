import 'package:band_names/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SatusPage extends StatelessWidget {
  const SatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serviSocket = Provider.of<SocketService>(context);
// serviSocket.socket.emit(event)
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("EStado del servidor :${serviSocket.serverStatus}"),
          ElevatedButton(
              onPressed: () async {
                
                serviSocket.socket.emit('emitir-mensaje',
                    {'nombre': 'Flutter', 'mensaje': 'Hola desde Flutter'});
              },
              child:const Icon(Icons.message))
        ],
      )),
    );
  }
}
