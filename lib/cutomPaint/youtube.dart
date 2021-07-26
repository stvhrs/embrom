
import 'package:flutter/material.dart';

class YgLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
          60,
          (60 * 0.9999958398610569)
              .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
      painter: RPSCustomPainter(),
    );
  }
}
//Add this CustomPaint widget to the Widget Tree

//Copy this CustomPainter code to the Bottom of the File

//Add this CustomPaint widget to the Widget Tree

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9622708, size.height * 0.2678125);
    path_0.cubicTo(
        size.width * 0.9510729,
        size.height * 0.2262083,
        size.width * 0.9182813,
        size.height * 0.1934167,
        size.width * 0.8766875,
        size.height * 0.1822188);
    path_0.cubicTo(
        size.width * 0.8006979,
        size.height * 0.1614167,
        size.width * 0.4967396,
        size.height * 0.1614167,
        size.width * 0.4967396,
        size.height * 0.1614167);
    path_0.cubicTo(
        size.width * 0.4967396,
        size.height * 0.1614167,
        size.width * 0.1927813,
        size.height * 0.1614167,
        size.width * 0.1167917,
        size.height * 0.1814271);
    path_0.cubicTo(
        size.width * 0.07600000,
        size.height * 0.1926146,
        size.width * 0.04240625,
        size.height * 0.2262188,
        size.width * 0.03120833,
        size.height * 0.2678125);
    path_0.cubicTo(
        size.width * 0.01121875,
        size.height * 0.3437917,
        size.width * 0.01121875,
        size.height * 0.5013750,
        size.width * 0.01121875,
        size.height * 0.5013750);
    path_0.cubicTo(
        size.width * 0.01121875,
        size.height * 0.5013750,
        size.width * 0.01121875,
        size.height * 0.6597500,
        size.width * 0.03120833,
        size.height * 0.7349375);
    path_0.cubicTo(
        size.width * 0.04241667,
        size.height * 0.7765313,
        size.width * 0.07519792,
        size.height * 0.8093229,
        size.width * 0.1168021,
        size.height * 0.8205313);
    path_0.cubicTo(
        size.width * 0.1935833,
        size.height * 0.8413229,
        size.width * 0.4967396,
        size.height * 0.8413229,
        size.width * 0.4967396,
        size.height * 0.8413229);
    path_0.cubicTo(
        size.width * 0.4967396,
        size.height * 0.8413229,
        size.width * 0.8006979,
        size.height * 0.8413229,
        size.width * 0.8766875,
        size.height * 0.8213229);
    path_0.cubicTo(
        size.width * 0.9182813,
        size.height * 0.8101250,
        size.width * 0.9510729,
        size.height * 0.7773229,
        size.width * 0.9622813,
        size.height * 0.7357396);
    path_0.cubicTo(
        size.width * 0.9822708,
        size.height * 0.6597500,
        size.width * 0.9822708,
        size.height * 0.5021667,
        size.width * 0.9822708,
        size.height * 0.5021667);
    path_0.cubicTo(
        size.width * 0.9822708,
        size.height * 0.5021667,
        size.width * 0.9830729,
        size.height * 0.3437917,
        size.width * 0.9622708,
        size.height * 0.2678125);
    path_0.close();
    path_0.moveTo(size.width * 0.9622708, size.height * 0.2678125);

    Paint paint0fill = Paint()..style = PaintingStyle.fill;
    paint0fill.color = Colors.green[400]!;
    canvas.drawPath(path_0, paint0fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.3989479, size.height * 0.6446354);
    path_1.lineTo(size.width * 0.6517083, size.height * 0.4990625);
    path_1.lineTo(size.width * 0.3989479, size.height * 0.3534792);
    path_1.close();
    path_1.moveTo(size.width * 0.3989479, size.height * 0.6446354);

    Paint paint1 = Paint()..style = PaintingStyle.fill;
    paint1.color = Colors.lime.withOpacity(1);
    canvas.drawPath(path_1, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
