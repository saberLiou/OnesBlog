import 'package:flutter/material.dart';
import 'package:ones_blog/data/models/location.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
    required this.location,
    this.imageUrl,
  });

  final Location location;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: MediaQuery.of(context).size.width / 1.5,
      child: Card(
        color: AppColors.muted,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              SpaceUnit.doubleBase,
            ),
          ),
        ),
        elevation: SpaceUnit.halfBase,
        child: Column(
          children: [
            Container(
              height: SpaceUnit.base * 20,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SpaceUnit.doubleBase),
                  topRight: Radius.circular(SpaceUnit.doubleBase),
                ),
              ),
              child: Image.network(
                'https://picsum.photos/seed/picsum/1024/768',
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: SpaceUnit.base,
                ),
                child: Center(
                  child: Text(
                    location.name,
                    style: AppTextStyle.title,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                right: SpaceUnit.base,
                bottom: SpaceUnit.base,
                left: SpaceUnit.base,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    location.cityAndArea ?? '',
                    style: AppTextStyle.content,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      Text(
                        location.avgScore.toString(),
                        style: AppTextStyle.content,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
