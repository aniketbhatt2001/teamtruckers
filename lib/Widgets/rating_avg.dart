import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AverageRatingIcon extends StatelessWidget {
  final double rating;
  final double size;

  AverageRatingIcon({required this.rating, this.size = 18});

  @override
  Widget build(BuildContext context) {
    int fullStars = 0;
    double value = rating;
    double decimalThreshold = 0.7;

    double decimalPart = value % 1;
    bool isDecimalGreaterOrEqual = decimalPart >= decimalThreshold;

    if (isDecimalGreaterOrEqual) {
      fullStars = rating.ceil();
    } else {
      fullStars = rating.floor();
    }

    final bool hasHalfStar = rating - fullStars >= 0.2;
    // if( rating - fullStars >= 0.2 && rating - fullStars < 0.7){
    //   has
    // }
    // print(hasHalfStar);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(fullStars, (index) {
        return Icon(
          FontAwesomeIcons.solidStar,
          size: size,
          color: Colors.yellow,
        );
      })
        ..addAll([
          if (hasHalfStar)
            Icon(
              FontAwesomeIcons.starHalfAlt,
              size: size,
              color: Colors.yellow,
            ),
        ]),
    );
  }
}
