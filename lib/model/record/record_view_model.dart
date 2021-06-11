import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:daily_running/repo/running_repository.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'activity.dart';

class RecordViewModel extends ChangeNotifier {
  bool _isExpand = true;
  bool _isPause = false;
  bool isRunning = false;
  bool isSave = false;
  int timeWorkingInSec = 0;
  double _distance = 0;
  double _currentSpeed = 0;
  double _averageSpeed = 0;
  Uint8List imageBytes;
  Timer timer;
  LatLngBounds bounds;
  bool isLoading = false;
  Uint8List startMarkerImage;
  Uint8List endMarkerImage;
  static final activityDateFormat = DateFormat("dd/MM/yyyy hh:mm");

  List<Marker> mapMarkers = [];

  CameraPosition initialLocation =
      CameraPosition(target: LatLng(10, 106), zoom: 14.47);
  GoogleMapController mapController;
// this will hold the generated polylines
  Set<Polyline> _polylines = {};
// this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
// this is the key object - the PolylinePoints
// which generates every polyline between start and finish
  StreamSubscription locationSubscription;
  List<Marker> markers = [];

  Set<Polyline> get polylines => _polylines;
  String get currentSpeed {
    return '${_currentSpeed.toStringAsFixed(2)} m/s';
  }

  String get timeWorking => getTimeWorking(timeWorkingInSec);

  static String getTimeWorking(int sec) {
    Duration duration = Duration(seconds: sec);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void setSaveButton(val) {
    isSave = val;
    notifyListeners();
  }

  String get averageSpeed => '${_averageSpeed.toStringAsFixed(2)} m/s';
  String get distanceString {
    return '${(_distance / 1000).toStringAsFixed(2)} Km';
  }

  int get runningPoint {
    return (_distance / 1000).floor();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timeWorkingInSec++;
    });
  }

  void initMarker(BuildContext context) async {
    startMarkerImage = await getMarker('start', context);
    endMarkerImage = await getMarker('end', context);
  }

  void startRunning(BuildContext context) async {
    if (isRunning) return;
    if (startMarkerImage == null || endMarkerImage == null)
      await initMarker(context);
    isRunning = true;
    startTimer();
    startTracking(context);
  }

  bool resetData() {
    isSave = false;
    markers = [];
    mapMarkers = [];
    imageBytes = null;
    _currentSpeed = 0;
    _distance = 0;
    timeWorkingInSec = 0;
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
    _isExpand = true;
    _isPause = false;
    isRunning = false;
    polylines.clear();
    polylineCoordinates.clear();
    if (mapController != null) mapController.dispose();
    cancelTracking();
    notifyListeners();
    return true;
  }

  void cancelTracking() {
    if (locationSubscription != null) locationSubscription.cancel();
  }

  void setInitialCamera() async {
    var location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
              location.latitude,
              location.longitude,
            ),
            tilt: 0,
            zoom: 30,
            bearing: 192.833),
      ),
    );
    polylineCoordinates.add(LatLng(location.latitude, location.longitude));
  }

  void createPolyline() {
    // create a Polyline instance
    // with an id, an RGB color and the list of LatLng pairs
    Polyline polyline = Polyline(
      polylineId: PolylineId('poly'),
      color: kPrimaryColor,
      points: polylineCoordinates,
    );

    // add the constructed polyline as a set of points
    // to the polyline set, which will eventually
    // end up showing up on the map
    _polylines.clear();
    _polylines.add(polyline);
    notifyListeners();
  }

  void calcDistance(
      {double startLat,
      double startLong,
      double endLat,
      double endLong}) async {
    _currentSpeed =
        Geolocator.distanceBetween(startLat, startLong, endLat, endLong);
    _distance += _currentSpeed;
  }

  void addMarker(double lat, double long) async {
    markers.add(
      Marker(
        markerId: MarkerId('${polylineCoordinates.length}'),
        position: LatLng(lat, long),
      ),
    );
  }

  void startTracking(BuildContext context) async {
    var location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    //for image
    addMarker(location.latitude, location.longitude);
    if (locationSubscription != null) locationSubscription.cancel();
    locationSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      intervalDuration: Duration(
        seconds: 1,
      ),
    ).listen(
      (newLocationData) {
        if (mapController != null) {
          if (polylineCoordinates.isNotEmpty)
            calcDistance(
              startLat: polylineCoordinates.last.latitude,
              startLong: polylineCoordinates.last.longitude,
              endLat: newLocationData.latitude,
              endLong: newLocationData.longitude,
            );
          addMarker(newLocationData.latitude, newLocationData.longitude);
          polylineCoordinates
              .add(LatLng(newLocationData.latitude, newLocationData.longitude));
          createPolyline();
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  newLocationData.latitude,
                  newLocationData.longitude,
                ),
                tilt: 0,
                zoom: 30,
                bearing: 192.833,
              ),
            ),
          );
        }
      },
    );
  }

  set isExpand(bool val) {
    _isExpand = val;
    notifyListeners();
  }

  void toggleExpand() {
    _isExpand = !_isExpand;
    notifyListeners();
  }

  void togglePause(BuildContext context) {
    _isPause = !_isPause;
    if (_isPause) {
      cancelTracking();
      timer.cancel();
    } else {
      startTimer();
      startTracking(context);
    }
    notifyListeners();
  }

  Future takeActivityPicture() async {
    cancelTracking();
    bounds = boundsFromLatLngList(polylineCoordinates);
    mapMarkers.addAll([
      Marker(
        icon: BitmapDescriptor.fromBytes(startMarkerImage),
        draggable: false,
        markerId: MarkerId('markerStart'),
        anchor: Offset(0.5, 1),
        zIndex: 2,
        position: polylineCoordinates.first,
      ),
      Marker(
        icon: BitmapDescriptor.fromBytes(endMarkerImage),
        draggable: false,
        markerId: MarkerId('markerEnd'),
        anchor: Offset(0.5, 1),
        zIndex: 2,
        position: polylineCoordinates.last,
      ),
    ]);
    notifyListeners();
    CameraUpdate cu = CameraUpdate.newLatLngBounds(bounds, 25);
    await mapController.moveCamera(cu);
    await Future.delayed(Duration(milliseconds: 500));
    imageBytes = await mapController.takeSnapshot();
  }

  Future<Uint8List> getMarker(String type, BuildContext context) async {
    if (type == 'start')
      return (await DefaultAssetBundle.of(context)
              .load('assets/images/marker_start.png'))
          .buffer
          .asUint8List();
    else
      return (await DefaultAssetBundle.of(context)
              .load('assets/images/marker_end.png'))
          .buffer
          .asUint8List();
  }

  Future stopRunning() async {
    cancelTracking();
    _averageSpeed = _distance / timeWorkingInSec;
    await takeActivityPicture();
    notifyListeners();
  }

  get isExpand => _isExpand;
  get isPause => _isPause;

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  Future<String> onSaveClick(String describe) async {
    isLoading = true;
    notifyListeners();
    String activityID = RunningRepo.uuid.v4();
    String activityImageUrl = await RunningRepo.postUint8ListData(
        data: imageBytes, folderPath: 'activity_photos', fileName: activityID);
    List<LatLngArrayList> latLngArrayList = polylineCoordinates
        .map((item) =>
            LatLngArrayList(latitude: item.latitude, longitude: item.longitude))
        .toList();
    Activity newActivity = Activity(
      activityID: activityID,
      dateCreated: activityDateFormat.format(DateTime.now()),
      describe: describe,
      distance: _distance,
      duration: timeWorkingInSec,
      latLngArrayList: latLngArrayList,
      pace: _averageSpeed,
      pictureURI: activityImageUrl,
      userID: RunningRepo.auth.currentUser.uid,
    );

    String result = await RunningRepo.pushActivity(newActivity);
    isLoading = false;
    notifyListeners();
    if (result == null)
      return null;
    else
      return Future.value(result);
  }
}
