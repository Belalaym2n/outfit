 import 'package:flutter/cupertino.dart';

class MenuModel {
  String pageName;
  final VoidCallback navigate;
  MenuModel({required this.navigate, required this.pageName});

  static List<MenuModel> getItems(BuildContext context) {
    return [
      MenuModel(
        navigate: () {
          print("Navigating to Home...");

         },
        pageName: "الصفحة الرئيسية",
      ),

      MenuModel(
        navigate: () {
         },
        pageName: "محاضرات",
      ),

      MenuModel(
        navigate: () {
         },
        pageName: "درجات الطلاب",
      ),



      MenuModel(
        navigate: () {
         },
        pageName: "الإشعارات",
      ),

      MenuModel(
        navigate: () {
         },
        pageName: "اتصل بنا",
      ),
    ];
  }
}
