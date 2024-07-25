//here we should be able to override the behaviours of the gui dot by extending the gui dot class.

/*
Here are the customziation that we are gonna be able to do
adjustable radius to glaal offset factor
ovrridable aiRespone method so that in future we can use streambuilder with firestore to allow players from around the world to compete.
overridable dot color and line paint color.
 */

import 'package:cellz_lite/business_logic/point.dart';
import 'package:cellz_lite/game_components/gui_dot.dart';

class CustomGuiDot extends Dot {
  CustomGuiDot({required Point myPoint, double radFactor = 0.13}) : super(myPoint, radFactor: radFactor);

  @override
  Future<void> aiResponse() async {
    //we need to override aiResponse so that it waits till the GameState.isUploading is false

    super.aiResponse();
  }

  //the ai response also passes the test
}
