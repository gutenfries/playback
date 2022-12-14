import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:playback/screens/app/app.dart';
import 'package:playback/shared/shared.dart';
import 'package:get/get.dart';

class MeTab extends GetView<HomeController> {
  const MeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: SizeConfig().screenHeight * .5,
          child: Stack(
            children: [
              const GradientBackground(
                needWave: false,
              ),
              /* Obx(
                () =>  */
              Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: 'https://picsum.photos/200',
                        imageBuilder: (context, imageProvider) => Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'controller.user.value!.name',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'controller.user.value!.email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'controller.user.value!.bio',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
