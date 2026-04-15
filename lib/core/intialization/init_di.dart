import 'package:get_it/get_it.dart';

import '../../features/compatapilityModel/di/outfit_di.dart';
import '../../features/login/di/login_di.dart';
import '../../features/profile/di/profile_di.dart';
import '../../features/signUp/di/register_di.dart';


final getIt = GetIt.instance;

Future<void> initDI() async {

  initialLoginDI(getIt);
  initialRegisterDI(getIt);
  initialOutfitDI(getIt);
  profileDi(getIt);

  // profileDI(getIt);
  // locationDI(getIt);
  // tripsDI(getIt);
  // complaintDI(getIt);
  // rate_di(getIt);
  // initialTripChatDI( );
  // get_ads_di(getIt);
  // initDependencies(getIt);
  // initialNotificationDI(getIt);
  //  problemDI(getIt);  // ⬅️ لازم لازم يتضاف!


}
