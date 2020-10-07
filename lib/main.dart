
import 'package:bandapp/src/page/status_page.dart';
import 'package:bandapp/src/services/sockets_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bandapp/src/page/home_page.dart';
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>SockerService(),)
      ],
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home':(BuildContext context)=>HomePage(),
          'status':(BuildContext context)=>StatusPage()
        },
      ),
    );
  }
}