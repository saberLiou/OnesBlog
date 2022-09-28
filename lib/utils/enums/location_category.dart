enum LocationCategory {
  restaurants(id: 1),
  spots(id: 2),
  lodgings(id: 3);

  const LocationCategory({
    required this.id,
  });

  final int id;
}
