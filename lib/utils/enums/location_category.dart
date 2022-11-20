import 'package:flutter/widgets.dart';
import 'package:ones_blog/l10n/l10n.dart';

enum LocationCategory {
  restaurants(id: 1),
  spots(id: 2),
  lodgings(id: 3);

  const LocationCategory({
    required this.id,
  });

  static final Map<int, LocationCategory> idTypes = {};
  final int id;

  static LocationCategory getById(int? id) {
    if (idTypes.isEmpty) {
      for (final value in LocationCategory.values) {
        idTypes[value.id] = value;
      }
    }

    return idTypes[id] ?? LocationCategory.restaurants;
  }

  String translate(AppLocalizations l10n) {
    switch (this) {
      case LocationCategory.restaurants:
        return l10n.restaurant;
      case LocationCategory.spots:
        return l10n.spot;
      case LocationCategory.lodgings:
        return l10n.lodging;
    }
  }

  Image defaultImage() {
    switch (this) {
      case LocationCategory.restaurants:
        return Image.asset(
          'images/default/restaurants.jpeg',
          fit: BoxFit.fill,
        );
      case LocationCategory.spots:
        return Image.asset(
          'images/default/spots.jpeg',
          fit: BoxFit.fill,
        );
      case LocationCategory.lodgings:
        return Image.asset(
          'images/default/lodgings.jpeg',
          fit: BoxFit.fill,
        );
    }
  }
}
