import 'package:flutter/material.dart';
import 'package:playpal/pages/components/emoji_art/three_question_marks.dart';
import 'package:twemoji/twemoji.dart';

class NoDogsUser extends StatelessWidget {
  const NoDogsUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.blue.shade600,
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 240),
          child: const Twemoji(
            emoji: '🐶',
            height: 100,
            width: 100,
          ),
        ),
        const ThreeQuestionMarks(),
        Container(
          padding: const EdgeInsets.only(top: 30),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 250,
            child: Text(
              'You have no dogs.\n\nAdd a dog to your profile to see who\'s out there!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NoDogsInArea extends StatelessWidget {
  const NoDogsInArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.indigo[400],
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 240),
          child: const Twemoji(
            emoji: '🐶',
            height: 100,
            width: 100,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 42, bottom: 220),
          child: const RotationTransition(
            turns: AlwaysStoppedAnimation(330 / 360),
            child: Twemoji(
              emoji: '💧',
              height: 20,
              width: 20,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(right: 42, bottom: 220),
          child: const RotationTransition(
            turns: AlwaysStoppedAnimation(30 / 360),
            child: Twemoji(
              emoji: '💧',
              height: 20,
              width: 20,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 100),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 250,
            child: Text(
              'There are no dogs in your area!\n\nCheck back later, or start sharing this app with your friends!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
