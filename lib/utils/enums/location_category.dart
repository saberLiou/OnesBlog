import 'package:ones_blog/l10n/l10n.dart';

enum LocationCategory {
  restaurants(id: 1),
  spots(id: 2),
  lodgings(id: 3);

  const LocationCategory({
    required this.id,
  });

  final int id;

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
}
