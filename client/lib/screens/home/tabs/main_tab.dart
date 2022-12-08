import 'package:flutter/material.dart';
import 'package:playback/models/response/users_response.dart';
import 'package:playback/screens/home/home.dart';
import 'package:playback/shared/constants/colors.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MainTab extends GetView<HomeController> {
  const MainTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => RefreshIndicator(
          child: _buildGridView(),
          onRefresh: () => controller.loadUsers(),
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return MasonryGridView.count(
      crossAxisCount: 4,
      itemCount: data!.length,
      itemBuilder: (BuildContext context, int index) => Container(
        color: ColorConstants.lightGray,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('${data![index].lastName} ${data![index].firstName}'),
            CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: data![index].avatar ??
                  'https://reqres.in/img/faces/1-image.jpg',
              placeholder: (context, url) => const Image(
                image: AssetImage('assets/images/icon_success.png'),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Text('${data![index].email}'),
          ],
        ),
      ),
    );
  }

  List<Datum>? get data {
    return controller.users.value == null ? [] : controller.users.value!.data;
  }
}
