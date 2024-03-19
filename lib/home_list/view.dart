import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:refresh_network/model/Detail.dart';
import 'package:refresh_network/refresh/sf_refresh.dart';

import 'logic.dart';

class HomeListPage extends StatelessWidget {
  HomeListPage({Key? key}) : super(key: key);

  final logic = Get.put(HomeListLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 700.w,
        width: double.infinity,
        child: buildRefreshListWidget<Data, HomeListLogic>(
            itemBuilder: (item, index) {
              return Container(
                  margin: EdgeInsets.only(top: 14.w, left: 15.w, right: 15.w),
                  child: HomeSearchUserWidget(item: item));
            },
            onItemClick: (item, __) {}),
      ),
    );
  }
}

class HomeSearchUserWidget extends StatelessWidget {
  final Data item;

  const HomeSearchUserWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        onTap: () {
          // AppNavigator.pushNewPXPage(
          //     UserDetailPage(userId: "${item.id}", circleId: 'null',)
          // );
        },
        child: Container(
          height: 96.w,
          margin: EdgeInsets.only(top: 10.w),
          color: Colors.black,
        ));
  }
}
