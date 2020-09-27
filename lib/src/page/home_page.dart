import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bandapp/src/models/band_model.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands =[
    Band(id:'1',name: 'Metallica',votes:5),
    Band(id:'2',name: 'Cuarteto',votes:5),
    Band(id:'3',name: 'Reik',votes:1),
    Band(id:'4',name: 'Noise',votes:2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('BandNames',style: TextStyle(color:Colors.black),),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (BuildContext context, int index) {
          return _bandTitle(bands[index]);
         },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:addNewBand,
      ),
    );
  }

  Widget _bandTitle(Band band) {
    return Dismissible(
          key:Key(band.id),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction){
            print('direction $direction');
            print('direction ${band.id}');
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
              print(band.name);
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
              child: Text('Addd'),
              onPressed: ()=> addBandName(textEditingController.text),
            ),
            CupertinoDialogAction(
              child: Text('Close'),
              isDestructiveAction: true,
              onPressed: ()=> addBandName(textEditingController.text),
            )
          ],
        );
      }
    );
  }

  void addBandName(String name){
    if(name.length>1){
      this.bands.add(new Band(id:DateTime.now().toString(),name: name,votes:0));
      setState(() {
        
      });
    }
    Navigator.pop(context);
  }
}