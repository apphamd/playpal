import 'package:flutter/material.dart';
import 'package:twemoji/twemoji.dart';

class ThreeQuestionMarks extends StatelessWidget {
  const ThreeQuestionMarks({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // right question mark
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 100, bottom: 400),
          child: const RotationTransition(
            turns: AlwaysStoppedAnimation(30 / 360),
            child: Twemoji(
              emoji: '❓',
              height: 50,
              width: 50,
            ),
          ),
        ),

        // left question mark
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(right: 100, bottom: 400),
          child: const RotationTransition(
            turns: AlwaysStoppedAnimation(330 / 360),
            child: Twemoji(
              emoji: '❓',
              height: 50,
              width: 50,
            ),
          ),
        ),

        // middle question mark
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 430),
          child: const Twemoji(
            emoji: '❓',
            height: 50,
            width: 50,
          ),
        ),
      ],
    );
  }
}
