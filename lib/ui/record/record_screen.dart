import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:daily_running/model/record/record_view_model.dart';
import 'package:daily_running/ui/record/finish_record_screen.dart';
import 'package:daily_running/ui/record/widgets/record_button_row.dart';
import 'package:daily_running/ui/record/widgets/time_distance_row.dart';
import 'package:daily_running/ui/user/widgets/blur_loading.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RecordScreen extends StatelessWidget {
  static String id = 'RecordScreen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            bool res = false;
            res = await CoolAlert.show(
              context: context,
              type: CoolAlertType.confirm,
              backgroundColor: Colors.white,
              title: "Hủy hoạt động",
              confirmBtnColor: kPrimaryColor,
              width: 50,
              text: "Bạn có muốn hủy hoạt động hiện tại ?",
              barrierDismissible: false,
              onConfirmBtnTap: () {
                Provider.of<RecordViewModel>(context, listen: false)
                    .resetData();

                Navigator.pop(context, true);
              },
              confirmBtnText: "Có",
              cancelBtnText: "Không",
              onCancelBtnTap: () => Navigator.pop(context, false),
            );
            return res;
          },
          child: Stack(
            children: [
              GoogleMapWidget(),
              TopSheetBar(),
              RunButton(),
              /* Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkResponse(
                    radius: 20,
                    onTap: () {
                      Provider.of<RecordViewModel>(context, listen: false)
                          .takeActivityPicture();
                    },
                    child: Icon(
                      FontAwesomeIcons.spotify,
                      color: kSpotifyColor,
                      size: 35,
                    ),
                  ),
                ),
                alignment: Alignment.bottomLeft,
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}

class RunButton extends StatelessWidget {
  const RunButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(seconds: 1),
      opacity: Provider.of<RecordViewModel>(context).isRunning ? 0 : 1,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Material(
            color: kLightPrimaryColor,
            shape: CircleBorder(),
            child: InkResponse(
              radius: 45,
              onTap: () => Provider.of<RecordViewModel>(context, listen: false)
                  .startRunning(context),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(
                  FontAwesomeIcons.running,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      mapToolbarEnabled: false,
      initialCameraPosition:
          CameraPosition(target: LatLng(10.8007, 106.6669), zoom: 14.47),
      myLocationEnabled: true,
      markers: Set.of(Provider.of<RecordViewModel>(context).mapMarkers),
      polylines: Provider.of<RecordViewModel>(context).polylines,
      onMapCreated: (GoogleMapController controller) {
        Provider.of<RecordViewModel>(context, listen: false).mapController =
            controller;
        Provider.of<RecordViewModel>(context, listen: false).setInitialCamera();
      },
    );
  }
}

class TopSheetBar extends StatelessWidget {
  const TopSheetBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: Provider.of<RecordViewModel>(context).isRunning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<RecordViewModel>(
            builder: (context, recordViewModel, child) {
              return Material(
                elevation: 50,
                color: Colors.transparent,
                child: AnimatedContainer(
                  height: recordViewModel.isExpand ? 190 : 30,
                  width: double.infinity,
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Visibility(
                              visible: recordViewModel.isExpand,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                child: Column(
                                  children: [
                                    TimeDistanceRow(
                                      velocity:
                                          Provider.of<RecordViewModel>(context)
                                              .currentSpeed,
                                      time:
                                          Provider.of<RecordViewModel>(context)
                                              .timeWorking,
                                      distance:
                                          Provider.of<RecordViewModel>(context)
                                              .distanceString,
                                    ),
                                    RecordButtonRow(
                                      onContinuePress: () {
                                        Provider.of<RecordViewModel>(context,
                                                listen: false)
                                            .togglePause(context);
                                      },
                                      onStopPress: () async {
                                        bool res = false;
                                        res = await CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.confirm,
                                          backgroundColor: Colors.white,
                                          title: "Kết thúc hoạt động",
                                          confirmBtnColor: kPrimaryColor,
                                          width: 50,
                                          text:
                                              "Bạn có muốn kết thúc hoạt động hiện tại ?",
                                          barrierDismissible: false,
                                          onConfirmBtnTap: () {
                                            Navigator.pop(context, true);
                                          },
                                          confirmBtnText: "Có",
                                          cancelBtnText: "Không",
                                          onCancelBtnTap: () =>
                                              Navigator.pop(context, false),
                                        );
                                        if (res) {
                                          if (Provider.of<RecordViewModel>(
                                                  context,
                                                  listen: false)
                                              .polylineCoordinates
                                              .isEmpty) {
                                            Provider.of<RecordViewModel>(
                                                    context,
                                                    listen: false)
                                                .resetData();
                                            Navigator.pop(context);
                                            return;
                                          }
                                          await Provider.of<RecordViewModel>(
                                                  context,
                                                  listen: false)
                                              .stopRunning();
                                          Navigator.pushNamed(
                                              context, FinishRecordScreen.id);
                                        }
                                      },
                                      onPausePress: () {
                                        Provider.of<RecordViewModel>(context,
                                                listen: false)
                                            .togglePause(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Provider.of<RecordViewModel>(context, listen: false)
                                .toggleExpand();
                          },
                          child: Ink(
                            child: Icon(
                              recordViewModel.isExpand
                                  ? Icons.arrow_drop_up_outlined
                                  : Icons.arrow_drop_down_outlined,
                              size: 30,
                            ),
                            width: double.infinity,
                          ),
                        ),
                      ],
                    ),
                  ),
                  duration: Duration(milliseconds: 200),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 20),
            child: kAppNameTextBlack,
          ),
        ],
      ),
    );
  }
}
