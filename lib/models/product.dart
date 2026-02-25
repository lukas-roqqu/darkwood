enum GrindType { beans, ground }

enum RoastLevel { light, mediumLight, medium, mediumDark, dark }

class ProductVariant {
  final String size;
  final GrindType grind;
  final double price;

  const ProductVariant({
    required this.size,
    required this.grind,
    required this.price,
  });

  String get label => '$size · ${grind == GrindType.beans ? 'Beans' : 'Ground'}';
}

class Product {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final String tastingNotes;
  final String origin;
  final RoastLevel roastLevel;
  final String process;
  final List<ProductVariant> variants;
  final String imagePath;
  final bool isDecaf;
  final bool isBarrelAged;

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.tastingNotes,
    required this.origin,
    required this.roastLevel,
    required this.process,
    required this.variants,
    required this.imagePath,
    this.isDecaf = false,
    this.isBarrelAged = false,
  });

  double get startingPrice =>
      variants.map((v) => v.price).reduce((a, b) => a < b ? a : b);

  ProductVariant get defaultVariant =>
      variants.firstWhere((v) => v.size == '250g' && v.grind == GrindType.beans,
          orElse: () => variants.first);
}
