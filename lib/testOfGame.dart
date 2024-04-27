import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/gestures.dart';

void main() {
  runApp(GameWidget(game: AimClickGame()));
}

class AimClickGame extends FlameGame {
  late ClickableObject clickableObject;
  TextComponent textComponet = TextComponent(
      'HErl',
      config: TextConfig(color: const Color(0xFFFFFFFF)),
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();


    textComponet = TextComponent();
      textComponet.anchor = Anchor.topCenter;
      textComponet.x = size.x / 2;
      textComponet.y = 50;

    clickableObject = ClickableObject()
      ..position = size * 0.3
      ..width = 100
      ..height = 100
      ..anchor = Anchor.center;

    add(textComponet);
    add(clickableObject);
  }
}

class ClickableObject extends PositionComponent {
  static final _paint = Paint()..color = Colors.red;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _paint);
  }

  bool onTapDown(TapDownInfo details) {
    // Handle tap event here
    removeFromParent();
    return true; // Return true to consume the event
  }
}