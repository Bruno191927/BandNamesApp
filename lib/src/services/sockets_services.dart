import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
enum ServerStatus{
  Online,
  Ofline,
  Conecting
}

class SockerService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Conecting;
  IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  Function get emit => this._socket.emit;

  SockerService(){
    this._initConfig();
  }

  void _initConfig(){
    this._socket = IO.io('http://192.168.0.100:3000',{
      'transports':['websocket'],
      'autoConnect':true,
    });

    this._socket.on('connect', (_) {
     this._serverStatus = ServerStatus.Online;
     notifyListeners();
    });

    this._socket.on('disconnect', (_){
      this._serverStatus = ServerStatus.Ofline;
      notifyListeners();
    });

    /*this._socket.on('nuevo-mensaje', (payload){
      print('nuevo mensaje: $payload');
      print('nombre: ${payload['nombre']}');
      print('mensaje: ${payload['mensaje']}');
      print(payload.containsKey('Mensaje2')?payload['Mensaje2']:'No hay mensaje');
    });*/
  }

}