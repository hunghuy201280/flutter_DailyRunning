import 'package:daily_running/model/home/post_view_model.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class ActivityView extends StatelessWidget {
  static final id = 'ActivityView';

  final CameraPosition cp = CameraPosition(target: LatLng(10, 10));
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Chi tiết hoạt động',
            style: kBigTitleTextStyle,
          ),
          backgroundColor: kPrimaryColor,
        ),
        backgroundColor: kConcreteColor,
        body: WillPopScope(
          onWillPop: () async {
            Provider.of<PostViewModel>(context, listen: false).disposeMap();
            return true;
          },
          child: ModalProgressHUD(
            inAsyncCall: Provider.of<PostViewModel>(context).isLoading,
            progressIndicator: Center(
              child: SpinKitWave(
                color: kPrimaryColor,
              ),
            ),
            opacity: 0.7,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: GoogleMap(
                initialCameraPosition: cp,
                mapType: MapType.normal,
                markers: Set.of(Provider.of<PostViewModel>(context).mapMarkers),
                polylines: Provider.of<PostViewModel>(context).polylines,
                onMapCreated: (mapController) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Provider.of<PostViewModel>(context, listen: false)
                        .showActivityToMap(context, mapController);
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
