import 'product.dart';
import 'review.dart';
import '../core/assets.dart';

const List<Product> products = [
  Product(
    id: 'under-milk-wood',
    name: 'Under Milk Wood',
    tagline: 'Melts to rich caramel in milk',
    description:
        'Not so much stuck between extremes as offering the best of both, Under Milk Wood was the first blend we created and represents the concept behind Dark Woods. A multiple Great Taste Award winner and Golden Fork 2016 recipient for Best Northern Product.',
    tastingNotes: 'Caramel, milk-white smoothness',
    origin: 'Brazil Passeio · India Kalladavarapula · Ethiopia Yirgecheffe',
    roastLevel: RoastLevel.medium,
    process: 'Washed',
    imagePath: DarkwoodAssets.underMilkWood,
    variants: [
      ProductVariant(size: '250g', grind: GrindType.beans, price: 12.75),
      ProductVariant(size: '250g', grind: GrindType.ground, price: 12.75),
      ProductVariant(size: '1kg', grind: GrindType.beans, price: 38.55),
    ],
    reviews: [
      Review(reviewer: 'Sarah M.', rating: 5, body: 'Absolutely beautiful in milk. Rich and smooth with just the right sweetness. My go-to every morning.'),
      Review(reviewer: 'James T.', rating: 4.5, body: 'That caramel note is real — especially as a flat white. Consistent bag after bag.'),
      Review(reviewer: 'Priya K.', rating: 5, body: 'Won\'t buy anything else now. The Golden Fork award says it all.'),
    ],
  ),
  Product(
    id: 'crow-tree',
    name: 'Crow Tree',
    tagline: 'Tastes of pure, dark chocolate',
    description:
        'Dark yet bright, this is a rarity amongst specialty coffees. Sourced from women farmers in Peru through the Café Femenino program, which supports female producers and invests directly in community infrastructure.',
    tastingNotes: 'Pure dark chocolate',
    origin: 'Peru Asproagro · Honduras Finca La Guadeloupe',
    roastLevel: RoastLevel.dark,
    process: 'Washed',
    imagePath: DarkwoodAssets.crowTree,
    variants: [
      ProductVariant(size: '250g', grind: GrindType.beans, price: 12.25),
      ProductVariant(size: '250g', grind: GrindType.ground, price: 12.25),
      ProductVariant(size: '1kg', grind: GrindType.beans, price: 37.05),
    ],
    reviews: [
      Review(reviewer: 'Oli R.', rating: 5, body: 'Proper dark chocolate hit without being bitter. Best espresso I\'ve had at home.'),
      Review(reviewer: 'Helen W.', rating: 4, body: 'Love the story behind the Café Femenino sourcing. Tastes great too — dark and bold.'),
    ],
  ),
  Product(
    id: 'deer-hill',
    name: 'Deer Hill',
    tagline: 'Notes of milk chocolate and hazelnut',
    description:
        'A modern interpretation of traditional Italian espresso. Specialty arabicas from South America and India are blended with high-quality Robusta from India\'s award-winning Harley Estate, left at mid-roast for a smooth, rich, full-bodied result.',
    tastingNotes: 'Milk chocolate and hazelnut',
    origin: 'Colombia · India Kalledevarapura & Harley Estate · Brazil',
    roastLevel: RoastLevel.mediumDark,
    process: 'Washed',
    imagePath: DarkwoodAssets.deerHill,
    variants: [
      ProductVariant(size: '250g', grind: GrindType.beans, price: 12.50),
      ProductVariant(size: '250g', grind: GrindType.ground, price: 12.50),
      ProductVariant(size: '1kg', grind: GrindType.beans, price: 37.50),
    ],
    reviews: [
      Review(reviewer: 'Marco D.', rating: 4.5, body: 'Smooth and rich — exactly what I want in an everyday espresso.'),
      Review(reviewer: 'Chloe B.', rating: 4, body: 'Lovely hazelnut finish. Works brilliantly as a filter too.'),
    ],
  ),
  Product(
    id: 'black-hill',
    name: 'Black Hill',
    tagline: 'Flavours of dark chocolate and rich caramel',
    description:
        '3-Star Great Taste Award 2024. A deep, rich espresso blending specialty arabica with Kaapi Royale specialty robusta from Harley Estate. Sweet and satisfying with milk, complex and smooth without.',
    tastingNotes: 'Dark chocolate and rich caramel',
    origin: 'Colombia El Ata · India Kalledevarapura & Harley Estate · Brazil Fazenda Passeio',
    roastLevel: RoastLevel.dark,
    process: 'Washed',
    imagePath: DarkwoodAssets.blackHill,
    variants: [
      ProductVariant(size: '250g', grind: GrindType.beans, price: 12.50),
      ProductVariant(size: '250g', grind: GrindType.ground, price: 12.50),
      ProductVariant(size: '1kg', grind: GrindType.beans, price: 37.50),
    ],
    reviews: [
      Review(reviewer: 'Dan F.', rating: 5, body: '3-star Great Taste and it shows. Deep, complex and holds up brilliantly with milk.'),
      Review(reviewer: 'Anna S.', rating: 5, body: 'Ordered a second bag before I even finished the first. That good.'),
      Review(reviewer: 'Tom H.', rating: 4.5, body: 'Excellent espresso — sweet caramel notes with a satisfying body.'),
    ],
  ),
  Product(
    id: 'common-grounds',
    name: 'Common Grounds',
    tagline: 'Notes of vanilla, dried fruits and milk chocolate',
    description:
        'A collaboration with Magic Rock Brewery. Ethiopian Yirgecheffe rested in bourbon barrels before roasting, imparting vanilla, dried fruit and sweet bourbon aromatics. Batches require up to two weeks aging — a cult favourite.',
    tastingNotes: 'Vanilla, dried fruits, milk chocolate, sweet bourbon aroma',
    origin: 'Ethiopia Yirgecheffe',
    roastLevel: RoastLevel.mediumLight,
    process: 'Washed · Bourbon Barrel Aged',
    imagePath: DarkwoodAssets.commonGrounds,
    isBarrelAged: true,
    variants: [
      ProductVariant(size: '250g', grind: GrindType.beans, price: 15.95),
      ProductVariant(size: '250g', grind: GrindType.ground, price: 15.95),
      ProductVariant(size: '1kg', grind: GrindType.beans, price: 47.85),
    ],
    reviews: [
      Review(reviewer: 'Rachel G.', rating: 5, body: 'The bourbon barrel aging is subtle but unmistakable. Vanilla sweetness with a gorgeous aroma.'),
      Review(reviewer: 'Luke P.', rating: 5, body: 'Cult favourite for a reason. Worth every penny for a special occasion bag.'),
      Review(reviewer: 'Nina V.', rating: 4.5, body: 'Complex and interesting. Nothing else quite like it.'),
    ],
  ),
  Product(
    id: 'good-morning-sunshine',
    name: 'Good Morning Sunshine',
    tagline: 'French toast on a summer\'s morning',
    description:
        'Sweet and complex high-altitude South & Central American arabicas. A medium roast that tempers natural acidity and adds body and depth whilst retaining stone fruit and milk chocolate sweetness. A perfect everyday coffee.',
    tastingNotes: 'Stone fruit, milk chocolate, sweet and balanced',
    origin: 'South & Central America (high altitude)',
    roastLevel: RoastLevel.medium,
    process: 'Washed',
    imagePath: DarkwoodAssets.goodMorningSunshine,
    variants: [
      ProductVariant(size: '250g', grind: GrindType.beans, price: 12.75),
      ProductVariant(size: '250g', grind: GrindType.ground, price: 12.75),
      ProductVariant(size: '1kg', grind: GrindType.beans, price: 38.55),
    ],
    reviews: [
      Review(reviewer: 'Fiona L.', rating: 5, body: 'Tastes exactly like its name — French toast with a drizzle of syrup. Brilliant morning coffee.'),
      Review(reviewer: 'Ben A.', rating: 4, body: 'Balanced and approachable. A great everyday option that doesn\'t get boring.'),
    ],
  ),
  Product(
    id: 'lamplight-decaf',
    name: 'Lamplight Decaf',
    tagline: 'Flavours of rich fruit cake',
    description:
        'Single-estate Peruvian coffee decaffeinated using the Swiss Water method — entirely chemical-free. Rich, cake-like sweetness with hints of dried fruit. A coffee without caffeine or compromise.',
    tastingNotes: 'Rich fruit cake, dried fruit, golden syrup',
    origin: 'Peru',
    roastLevel: RoastLevel.medium,
    process: 'Washed · Swiss Water Decaf',
    imagePath: DarkwoodAssets.lamplightDecaf,
    isDecaf: true,
    variants: [
      ProductVariant(size: '250g', grind: GrindType.beans, price: 13.25),
      ProductVariant(size: '250g', grind: GrindType.ground, price: 13.25),
      ProductVariant(size: '1kg', grind: GrindType.beans, price: 40.50),
    ],
    reviews: [
      Review(reviewer: 'Claire N.', rating: 5, body: 'The best decaf I\'ve ever tasted — you genuinely wouldn\'t know. Rich and full-bodied.'),
      Review(reviewer: 'Pete O.', rating: 4.5, body: 'Swiss Water method makes a real difference. Clean, no off-flavours. Will reorder.'),
    ],
  ),
  Product(
    id: 'arboretum',
    name: 'Arboretum',
    tagline: 'A showcase of fruit and citrus',
    description:
        'Our lightest espresso — a seasonal celebration of nature and origin. Changes regularly to reflect the freshest and most complex coffees we can find. Bursting with red fruit, sweet and vibrant in milk, bright and juicy black.',
    tastingNotes: 'Red fruit, citrus, naturally sweet',
    origin: 'Panama Don Manelia La Huella · Costa Rica Beneficio Brunas del Zurqui',
    roastLevel: RoastLevel.light,
    process: 'Natural & Washed (seasonal)',
    imagePath: DarkwoodAssets.arboretum,
    variants: [
      ProductVariant(size: '250g', grind: GrindType.beans, price: 13.25),
      ProductVariant(size: '250g', grind: GrindType.ground, price: 13.25),
      ProductVariant(size: '1kg', grind: GrindType.beans, price: 39.75),
    ],
    reviews: [
      Review(reviewer: 'Zoe M.', rating: 5, body: 'Bright and fruity — almost like a juice when brewed as filter. Stunning coffee.'),
      Review(reviewer: 'Adam C.', rating: 4.5, body: 'The Panama lot is exceptional. Red fruit notes are vivid and the sweetness is natural.'),
    ],
  ),
  Product(
    id: 'driftwood',
    name: 'Driftwood',
    tagline: 'Caramel, almond & stone fruit',
    description:
        'Our signature Colombian, sourced from El Ata estate in Tolima at 1650–1900m altitude. Year-round availability thanks to the estate\'s dual harvest cycles. Designed as a filter coffee but suits a bright, fruity espresso too.',
    tastingNotes: 'Caramel, almond, stone fruit',
    origin: 'Colombia El Ata, Tolima (1650–1900m)',
    roastLevel: RoastLevel.light,
    process: 'Washed',
    imagePath: DarkwoodAssets.driftwood,
    variants: [
      ProductVariant(size: '250g', grind: GrindType.beans, price: 12.75),
      ProductVariant(size: '250g', grind: GrindType.ground, price: 12.75),
      ProductVariant(size: '1kg', grind: GrindType.beans, price: 38.55),
    ],
    reviews: [
      Review(reviewer: 'Sam K.', rating: 5, body: 'My favourite single origin. Caramel and almond in espresso, stone fruit as a filter — versatile and delicious.'),
      Review(reviewer: 'Jess R.', rating: 4, body: 'The El Ata estate produces something really special. Consistent across bags too.'),
    ],
  ),
];
