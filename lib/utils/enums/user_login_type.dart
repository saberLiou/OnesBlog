import 'package:ones_blog/l10n/l10n.dart';

enum UserLoginType {
  user(id: 1),
  location(id: 2);

  const UserLoginType({
    required this.id,
  });

  static final Map<int, UserLoginType> idTypes = {};
  final int id;

  static UserLoginType getById(int? id) {
    if (idTypes.isEmpty) {
      for (final value in UserLoginType.values) {
        idTypes[value.id] = value;
      }
    }

    return idTypes[id] ?? UserLoginType.user;
  }

  String translate(AppLocalizations l10n) {
    switch (this) {
      case UserLoginType.user:
        return l10n.user;
      case UserLoginType.location:
        return l10n.location;
    }
  }
}
