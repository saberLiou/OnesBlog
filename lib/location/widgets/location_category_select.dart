import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ones_blog/l10n/l10n.dart';
import 'package:ones_blog/utils/app_text_style.dart';
import 'package:ones_blog/utils/constants/space_unit.dart';
import 'package:ones_blog/utils/enums/location_category.dart';

class LocationCategorySelect extends StatelessWidget {
  const LocationCategorySelect({
    super.key,
    required this.onChanged,
    required this.l10n,
    this.value = LocationCategory.restaurants,
  });

  final ValueChanged<dynamic>? onChanged;
  final AppLocalizations l10n;
  final LocationCategory value;

  @override
  Widget build(BuildContext context) => Container(
        width: 300,
        height: SpaceUnit.base * 6,
        margin: const EdgeInsets.symmetric(
          vertical: SpaceUnit.doubleBase,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(SpaceUnit.base),
          ),
        ),
        child: DropdownButtonFormField2(
          isExpanded: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          value: value,
          onChanged: onChanged,
          items: LocationCategory.values
              .map(
                (category) => DropdownMenuItem<LocationCategory>(
                  value: category,
                  child: Center(
                    child: Text(
                      category.translate(l10n),
                      style: AppTextStyle.content,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
}
