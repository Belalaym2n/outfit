
import 'package:flutter/material.dart';

 import '../utils/app_colors.dart';
import '../utils/app_constants.dart';



class OfflineNetwork extends StatefulWidget {
  const OfflineNetwork({super.key});

  @override
  State<OfflineNetwork> createState() => _CheckNetworkState();
}

class _CheckNetworkState extends State<OfflineNetwork> {
  bool isDesktop(double width) => width >= 1024;

  bool isTablet(double width) => width >= 600 && width < 1024;

  bool isMobile(double width) => width < 600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          if (isDesktop(w)) {
            return buildOfflineNetwork(true);
          } else if (isTablet(w)) {
            return buildOfflineNetwork(false);
          } else {
            return buildOfflineNetwork(false);
          }
        },
      ),
    );
  }

  Widget buildOfflineNetwork(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Icon(
            Icons.wifi_off,
            color: AppColors.primaryColor,
            size:  isDesktop?
            AppConstants.w * 0.2:
            AppConstants.w * 0.28,
          ),
        ),
        SizedBox(height: AppConstants.h * 0.02),
        Text(
          "No Internt Connection ",
          style: TextStyle(
            fontSize: isDesktop?
            AppConstants.w * 0.018:
            AppConstants.w * 0.04,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppConstants.h * 0.01),
        Text(
          "No Internet Connection found check your \n            connection and try again",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize:  isDesktop?
            AppConstants.w * 0.01:
            AppConstants.w * 0.03,
          ),
        ),
        IconButton(icon: Icon(Icons.refresh), onPressed: () {}),
      ],
    );
  }
}
