import 'dart:io';
import 'package:bandapp/src/services/sockets_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bandapp/src/models/band_model.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands =[];

  @override
  void initState() { 
    final socketService = Provider.of<SockerService>(context,listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
    
  }

  void _handleActiveBands(dynamic payload){
     this.bands = (payload as List)
      .map((band) => Band.fromMap(band)).toList();

      setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SockerService>(context,listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SockerService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title:Text('BandNames',style: TextStyle(color:Colors.black),),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus==ServerStatus.Online)
            ?Icon(Icons.check_circle,color: Colors.blue,)
            :Icon(Icons.offline_bolt,color: Colors.red,),
          )
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (BuildContext context, int index) {
                return _bandTitle(bands[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:addNewBand,
      ),
    );
  }

  Widget _bandTitle(Band band) {

    final socketService = Provider.of<SockerService>(context,listen: false);
    return Dismissible(
          key:Key(band.id),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction){
            print('direction $direction');
            print('direction ${band.id}');
            socketService.socket.emit('delete-band',{'id':band.id});
          },
          background: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.red,
            child: Align(
              child: Text('Delete Band',style: TextStyle(color:Colors.white),),
              alignment: Alignment.centerLeft,
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(band.name.substring(0,2)),
              backgroundColor: Colors.blue[100],
            ),
            title: Text(band.name),
            trailing: Text('${band.votes}',style: TextStyle(fontSize: 20),),

            onTap: (){
              socketService.socket.emit('vote-band',{'id':band.id});
            },
          ),
    );
  }

  addNewBand(){
    final textEditingController = TextEditingController();

    if(Platform.isAndroid){
      return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('New band name: '),
            content: TextField(
              controller: textEditingController,
            ),
            actions: [
              MaterialButton(
                onPressed: ()=>addBandName(textEditingController.text),
                elevation: 5,
                child: Text('Add'),
                textColor: Colors.blue,
              )
            ],
          );
        }
      );
    }

    return showCupertinoDialog(
      context: context, 
      builder: (context){
        return CupertinoAlertDialog(
          title: Text('New Band'),
          content: CupertinoTextField(
            controller:textEditingController
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Add'),
              onPressed: ()=> addBandName(textEditingController.text),
            ),
            CupertinoDialogAction(
              child: Text('Close'),
              isDestructiveAction: true,
              onPressed:()=> Navigator.pop(context),
            )
          ],
        );
      }
    );
  }

  void addBandName(String name){

    final socketService = Provider.of<SockerService>(context,listen: false);
    if(name.length>1){
      socketService.socket.emit('add-band',{'name':name});
    }
    Navigator.pop(context);
  }

  Widget _showGraph(){
    Map<String, double> dataMap = new Map();

    bands.forEach((band) { 
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });

    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(dataMap: dataMap)
    );
  }
}