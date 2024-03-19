import 'package:flutter/material.dart';
import 'package:get/get.dart';

////封装一个SFAppBar 要求leading 可以放置自定义图片或者文字或者空 默认是图片返回 Title也是 默认是空可以传文字 右侧按钮也是 默认是空
class SFAppBar extends AppBar {
  SFAppBar({
    Key? key,
    String title = "",
    Widget? leading,
    Widget? right,
    Color? backgroundColor,
    Color? titleColor,
    Color? iconColor,
    double? elevation,
    bool centerTitle = true,
  }) : super(
          key: key,
          title: Text(
            title,
            style: TextStyle(
              color: titleColor ?? Colors.white,
              fontSize: 18,
            ),
          ),
          leading: leading ??
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: iconColor ?? Colors.white,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
          actions: right != null
              ? <Widget>[
                  right,
                ]
              : null,
          backgroundColor: backgroundColor ?? Colors.blue,
          elevation: elevation ?? 0,
          centerTitle: centerTitle,
        );
}