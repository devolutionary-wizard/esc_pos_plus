import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrintUtils {
  Future<Uint8List> convertToImage(String label,
      {double fontSize = 16, fontWeight = FontWeight.w500}) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final backgroundPaint = Paint()..color = Colors.white;
    const backgroundRect = Rect.fromLTRB(375, 10000, 0, 0);
    final backgroundPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(backgroundRect, const Radius.circular(0)),
      )
      ..close();
    canvas.drawPath(backgroundPath, backgroundPaint);

    final ticketNum = TextPainter(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.left,
        text: TextSpan(
            text: label,
            style: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
                fontWeight: fontWeight)));
    ticketNum
      ..layout(maxWidth: 375)
      ..paint(canvas, const Offset(0, 0));
    canvas.restore();
    final picture = recorder.endRecording();
    final pngBytes =
        await (await picture.toImage(375.toInt(), ticketNum.height.toInt() + 5))
            .toByteData(format: ImageByteFormat.png);
    return pngBytes!.buffer.asUint8List();
  }

  Future<Uint8List> enerateImageFromString(
    String text,
    TextAlign align,
  ) async {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(
        recorder,
        Rect.fromCenter(
          center: const Offset(0, 0),
          width: 550,
          height: 200, // cheated value, will will clip it later...
        ));
    TextSpan span = TextSpan(
      style: const TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      text: text,
    );
    TextPainter tp = TextPainter(
        text: span,
        maxLines: 3,
        textAlign: align,
        textDirection: TextDirection.ltr);
    tp.layout(minWidth: 200, maxWidth: 200);
    tp.paint(canvas, const Offset(0.0, 0.0));
    var picture = recorder.endRecording();
    final pngBytes = await picture.toImage(
      tp.size.width.toInt(),
      tp.size.height.toInt() - 2, // decrease padding
    );
    final byteData = await pngBytes.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
