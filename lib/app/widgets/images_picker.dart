import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/utils/app_colors.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';

class ImagesPicker extends StatelessWidget {
  const ImagesPicker({
    super.key,
    this.onPickedFromCamera,
    this.onPickedFromGallery,
  });

  final GestureTapCallback? onPickedFromCamera;
  final GestureTapCallback? onPickedFromGallery;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: 280,
      height: 100,
      margin: const EdgeInsets.only(
        bottom: SpaceUnit.doubleBase,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primary,
          width: SpaceUnit.quarterBase,
        ),
      ),
      child: TextButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => AlertDialog(
              title: Text(l10n.uploadImagesTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: onPickedFromGallery,
                    child: ListTile(
                      title: Text(l10n.fromGallery),
                      leading: const Icon(
                        Icons.image,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 1,
                    color: AppColors.primary,
                  ),
                  InkWell(
                    onTap: onPickedFromCamera,
                    child: ListTile(
                      title: Text(l10n.fromCamera),
                      leading: const Icon(
                        Icons.camera,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(
          FontAwesomeIcons.photoFilm,
          color: AppColors.muted,
        ),
      ),
    );
  }
}
