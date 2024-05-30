import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:my_farm/models/cropModel.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  static const LatLng center = LatLng(37.96201, 13.17558);

  late MapboxMapController controller;
  final ScrollController _scrollController = ScrollController();

  //takes the list of crops from the model
  final List<Map<String, LatLng>> _cropCenters = crops.map((crop) => {crop.name: LatLng(crop.center[0], crop.center[1])}).toList();

  @override
  void initState() {
    super.initState();
    //initialzing the map
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
  // Ensure scroll controller and context are available
  if (_scrollController.hasClients) {
    final double itemWidth = MediaQuery.of(context).size.width - 16;

    // Calculate the clamped index to avoid out-of-bounds access
    final int index = (_scrollController.offset / itemWidth).clamp(0, _cropCenters.length - 1).round();

    // Safely access the selected LatLng object
    final LatLng selectedLatLng = _cropCenters[index].values.first;

    // Animate camera with safe null check
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(selectedLatLng, 16),
    );
    } else {
    print("Scroll controller has no clients or context is null");
  }
}


  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    //_updateGeoJsonSource();
    controller.onFeatureTapped.add(onFeatureTap);
  }

  void onFeatureTap(dynamic featureName, Point<double> point, LatLng coordinates) {

    final snackBar = SnackBar(
      content: Text(
        "Feature id: $featureName,",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Map<String, dynamic> generateGeoJson(List<Crop> crops) {
    return {
      "type": "FeatureCollection",
      "features": crops.map((crop) {
        return {
          "type": "Feature",
          "id": crop.name,
          "properties": {
            "name": crop.name,
          },
          "geometry": {
            "type": "Polygon",
            "coordinates": [crop.coordinates],
          }
        };
      }).toList(),
    };
    }

  void _onStyleLoadedCallback() async {

    final fills = generateGeoJson(crops);
    //await controller.addGeoJsonSource("moving", _movingFeature(0));

    //new style of adding sources
    await controller.addSource("fills", GeojsonSourceProperties(data: fills));

    await controller.addFillLayer(
      "fills",
      "fills",
      const FillLayerProperties(
        fillColor: '#53b267',
        fillOpacity: 0.4
      ),
      belowLayerId: "waterway-label",
    );

    await controller.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
          lineColor: const Color.fromARGB(255, 238, 226, 65).toHexStringRGB(),
          lineWidth: [
            Expressions.interpolate,
            ["linear"],
            [Expressions.zoom],
            11.0,
            2.0,
            20.0,
            10.0
          ]),
    );

    await controller.addCircleLayer(
      "fills",
      "circles",
      CircleLayerProperties(
        circleRadius: 4,
        circleColor: const Color.fromARGB(255, 185, 77, 27).toHexStringRGB(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children:[
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: MapboxMap(
              dragEnabled: false,
              onStyleLoadedCallback: _onStyleLoadedCallback,
              accessToken: 'pk.eyJ1IjoiZ2Fic2NhMjAwMSIsImEiOiJjbHY2ZHYwb2wwZDk1MmlvYm5xajVjaXB2In0.cXLIE8zgIn-334AudmdFWA',
              initialCameraPosition: const CameraPosition(
                target: center,
                zoom: 14.0,
              ),
              //styleString: 'mapbox://styles/mapbox/satellite-v9',
              onMapCreated: _onMapCreated,
              styleString: 'mapbox://styles/gabsca2001/clwtboqiz01ck01qs7nqifli0',
              annotationOrder: const [],
            ),
          ),
          Positioned(
            top: 20,
            child: SizedBox(
              height: 130,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                controller: _scrollController,
                physics: const PageScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: _cropCenters.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 130,
                      width: MediaQuery.of(context).size.width - 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            _cropCenters[index].keys.first,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Latitude: ${_cropCenters[index].values.first.latitude.toStringAsFixed(4)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            'Longitude: ${_cropCenters[index].values.first.longitude.toStringAsFixed(4)}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),

                        ],
                      ),
                    ),
                  );
                },
              )
            ),
          ),
        ],
      ),
    );
  }
}