import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

// ignore: constant_identifier_names
enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late Socket _socket;
  ServerStatus get serverStatus => _serverStatus;

  Socket get socket => _socket;

  SocketService() {
    _initCOnfig();
  }

  void _initCOnfig() async {
    String urlSocket = 'http://192.168.8.56:3000';
    // Dart client
    _socket = io(
        urlSocket,
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect()
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build()
        //  {
        //   'setTransports': ['websocket'],
        //   // 'transport': ['websocket'],
        //   'autoConnect': true
        //   // 'autoConnect': true
        // }
        );
    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // _socket.on('nuevo-mensaje', (payload) {
    //   print('nuevo mensaje: $payload  ');
    //   // print('nombre' + payload['name']);
    //   // print('mesaje' + payload['mensaje']);
    //   // print(payload.containsKey('mensaje2')
    //   //     ? payload['mensaje2']
    //   //     : 'No hay mensaje2');
    // });
  }
}
