import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class TheLocation extends StatefulWidget {
  final double latitude;
  final double longitude;
  TheLocation({@required this.latitude,@required this.longitude});
  @override
  _TheLocationState createState() => _TheLocationState();
}

class _TheLocationState extends State<TheLocation> {
  Completer<GoogleMapController> _controller = Completer();
  @override
  void initState() {
    super.initState();
    customIcon();
  }

  BitmapDescriptor myCustomIcon;
  void customIcon() async {
    myCustomIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),'assets/images/logo1.png');
  }

  @override
  Widget build(BuildContext context){
    List<Marker> allMarkers = [
      Marker(
          icon: myCustomIcon,
          infoWindow: InfoWindow(title: 'موقع الطلب'),
          markerId: MarkerId('موقع الطلب'),
          position: LatLng(widget.latitude,widget.longitude)),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
          child: Scaffold(
        appBar: AppBar(
          title: Text(' الموقع على الخريطة '),
          centerTitle: true,
          actions: [
            Icon(Icons.location_on),
          ],
        ),
        body:  Stack(
            children: [
              GoogleMap(
                markers: Set.from(allMarkers),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  setState(() {});
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.latitude,widget.longitude),
                  zoom: 10.0,
                ),
                mapType: MapType.normal,
              ),
            ],
          ),
        
      ),
    );
  }
}
