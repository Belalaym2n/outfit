import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart' show AppColors;
import '../utils/app_constants.dart' show AppConstants;

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor,
                side: BorderSide(
                  color: backgroundColor ?? Theme.of(context).primaryColor,
                ),
                padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(text),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: textColor,
                padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(8),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(text),
            ),
    );
  }
}

Widget large_button({
  required VoidCallback? onPressed, // ✅ كده يقبل null
  required String buttonName,
  bool isDisable = false,
  IconData? icon,
  Color? color,
  bool isDesktop = false,
}) => Align(
  alignment: Alignment.center,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor:color==null? AppColors.primaryColor :color,
      minimumSize: Size(AppConstants.w * 0.8, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),

    onPressed: isDisable ? null : onPressed,

    // ✅ مش لازم تعمل async call هنا
    child: Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        if(icon!=null)
          Icon(icon,color: Colors.white,size:  AppConstants.w / 18,),
if(icon!=null)
  SizedBox(
    width: AppConstants.w*0.02),
          Text(
            buttonName,
            style: TextStyle(
              color: Colors.white,
              fontSize: !isDesktop ? AppConstants.w / 18 : AppConstants.w / 65,
              fontFamily: 'Nexa Bold 650',
            ),
          ),
        ],
      ),
    ),
  ),
);
