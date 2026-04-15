import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

large_admin_button({
  required String text,
  required Function onTap
}){
  return        SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: (){onTap();},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child:   Text(
       text,
        style: TextStyle(fontSize: 16),
      ),
    ),
  );
}