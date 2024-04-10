import 'dart:async';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:log_in/login.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'package:firebase_database/firebase_database.dart';
 

final firebaseApp = Firebase.app();
final rtdb = FirebaseDatabase.instanceFor(app: firebaseApp , databaseURL: 'https://my-project-1579067571295-default-rtdb.firebaseio.com/');

final socket = WebSocket(Uri.parse('ws://172.20.25.116:9000/test1'),timeout: Duration(seconds: 30));


LatLng tempPos = LatLng(22.7196,75.8577);




 

 
 



class SimpleMap extends StatefulWidget {
  @override
  _SimpleMapState createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMap> {
 

 

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kInitialPosition = CameraPosition(
      target: LatLng(23.25941, 77.41225),
      zoom: 4,
      tilt: 0,
      bearing: 0);

final TextEditingController _serverController = TextEditingController();
 
  

     
  
pushData(int data,DatabaseReference ref,WebSocket socket){

  socket.send('[2, "12345", "Authorize", { "idTag":"pradhumn"   }]');
   socket.messages.listen((message) {
   print(message);
});
   Navigator.pushNamed(context, 'chargePointHome');


 
  }


  signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const MyLogin(),
      ),
    );
  }
  mapUpdate()async{
  String uid='pj1';
final ref = FirebaseDatabase.instance.ref();
 final lat= await ref.child('chargePoint/${uid}/lattitde').get();
  final lng= await ref.child('chargePoint/${uid}/longitude').get();
 double ln=double.parse(lng.value.toString());
 double lt=double.parse(lat.value.toString());
 print(lt+ln);
  myMarker.add(Marker(markerId: MarkerId("next"),
   

  position:LatLng(ln,lt),
     infoWindow: const InfoWindow(
            title: 'Cu   Location',
            
            
          )
  ),
  );
}

  final List<Marker> myMarker = [];
  final List<Marker> markerList = [
  ];

  @override
  void initState() {
    super.initState();
    myMarker.addAll(markerList);
    packdata();
    // mapUpdate();
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print('error$error');
    });

    return await Geolocator.getCurrentPosition();
  }
      
 
//  
  packdata() {
    getUserLocation().then((value) async {
      // print('My Location');
      // print('${value.latitude} ${value.longitude}');
  
      myMarker.add(Marker(
          markerId: MarkerId('Second'),
          position: LatLng(value.latitude, value.longitude),
          
          infoWindow: const InfoWindow(
            title: 'Current Location',
            
            
          )));
          
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude+2),
        zoom: 15,
      );

      final GoogleMapController controller = await _controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      setState(() {});
    });
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('EV Charging station'),
        ),
        body: Stack(children: [
          GoogleMap(
            initialCameraPosition: _kInitialPosition,
            mapType: MapType.satellite,
            markers: Set<Marker>.of(myMarker),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                 Container(
                  child: TextButton(
            onPressed: () {
                 DatabaseReference ref = FirebaseDatabase.instance.ref("users/123");
                  pushData(12, ref,socket);

               
            },
            child: Text(
               'Stations Nearby',
              textAlign: TextAlign.left,
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Color.fromARGB(255, 236, 44, 10),
                  fontSize: 18),
            ),
            style: ButtonStyle(),
          ),
                 ),
              Container(
                // padding:EdgeInsets.only(top: 625),
                child: TextButton(
                onPressed: () {
                  signOut();
                },
                child: Text(
                  
                  'Sign Out',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.red,
                      fontSize: 23),
                ),
                style: ButtonStyle(),
              ),
              ),
               Container(
                // padding:EdgeInsets.only(top: 625),
                child: TextButton(
                onPressed: () {
                   mapUpdate();
                 
                },
                child: Text(
                  
                  'Refresh',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.red,
                      fontSize: 23),
                ),
                style: ButtonStyle(),
              ),
              ),
               
               
           
             
            


              Container(
                // padding:EdgeInsets.only(right: 05,top: 475),
                child: FloatingActionButton(
                  
                  onPressed: () {
                    packdata();
                  },
                  child: const Icon(Icons.radio_button_checked),
                ),
              )
            ],
          )
        ]));
  }
}
