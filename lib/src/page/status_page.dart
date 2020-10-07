import 'package:bandapp/src/services/sockets_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SockerService>(context);

    _emitir(){
      socketService.emit(
        'emitir-mensaje',
        {
          'nombre':'Flutter',
          'Mensaje':'Hola desde Flutter'
        }
      );
    }


    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server Status: ${socketService.serverStatus}')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: (){
          _emitir();
        },
      ),
    );
  }
}