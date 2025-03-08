import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marvel_animation_app/shared/domain/models/item_model.dart';
import 'package:marvel_animation_app/shared/presentation/tokens/tokens.dart';

class CustomCard extends ConsumerWidget {
  const CustomCard({super.key, required this.item, required this.cardPressed, required this.cardAction});
  final ItemModel item;
  final VoidCallback cardPressed;
  final VoidCallback cardAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: cardPressed,
      child: Container(
        color: CustomColor.BRAND_PRIMARY_00,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                item.imageUrl,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 5,
              color: CustomColor.BRAND_PRIMARY_01,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        item.title.toUpperCase(),
                        style: CustomTextStyle.FONT_STYLE_TITLE_CARD,
                      ),
                    ),
                    Flexible(
                        child: Text(
                      item.subtitle,
                      style: CustomTextStyle.FONT_STYLE_DESCRIPTION_CARD,
                    )),
                  ],
                ),
              ),
            ),
            ClipPath(
              clipper: SlantedTopClipper(),
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: double.infinity,
                color: CustomColor.BRAND_PRIMARY_01,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: Spacing.SPACE_RESPONSIVE_XS, left: 2, right: 2),
                  child: Text(
                    item.buttonText,
                    style: CustomTextStyle.FONT_STYLE_BUTTON_CARD,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SlantedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height); // Punto inferior izquierdo
    path.lineTo(size.width, size.height); // Punto inferior derecho
    path.lineTo(size.width,
        size.height * 0.1); // Punto superior derecho (leve inclinación)
    path.lineTo(0, size.height * 0.2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
