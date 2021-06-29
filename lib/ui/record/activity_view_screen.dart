import 'package:daily_running/model/home/post_view_model.dart';
import 'package:daily_running/model/user/other_user/other_profile_view_model.dart';
import 'package:daily_running/ui/home/widgets/post_view.dart';
import 'package:daily_running/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class ActivityView extends StatelessWidget {
  static final id = 'ActivityView';
  final ActivityViewType type;
  final CameraPosition cp = CameraPosition(target: LatLng(10, 10));

  ActivityView({@required this.type});
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
            if (type == ActivityViewType.FromHomeScreen)
              Provider.of<PostViewModel>(context, listen: false).disposeMap();
            else {
              Provider.of<OtherProfileViewModel>(context, listen: false)
                  .disposeMap();
            }
            return true;
          },
          child: ModalProgressHUD(
            inAsyncCall: type == ActivityViewType.FromHomeScreen
                ? Provider.of<PostViewModel>(context).isLoading
                : Provider.of<OtherProfileViewModel>(context).isLoading,
            progressIndicator: Center(
              child: SpinKitWave(
                color: kPrimaryColor,
              ),
            ),
            opacity: 0.7,
            child: Stack(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: GoogleMap(
                    initialCameraPosition: cp,
                    mapType: MapType.normal,
                    markers: type == ActivityViewType.FromHomeScreen
                        ? Set.of(Provider.of<PostViewModel>(context).mapMarkers)
                        : Set.of(Provider.of<OtherProfileViewModel>(context)
                            .mapMarkers),
                    polylines: type == ActivityViewType.FromHomeScreen
                        ? Provider.of<PostViewModel>(context).polylines
                        : Provider.of<OtherProfileViewModel>(context).polylines,
                    onMapCreated: (mapController) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (type == ActivityViewType.FromHomeScreen)
                          Provider.of<PostViewModel>(context, listen: false)
                              .showActivityToMap(context, mapController);
                        else {
                          Provider.of<OtherProfileViewModel>(context,
                                  listen: false)
                              .showActivityToMap(context, mapController);
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: kAppNameTextBlack,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
