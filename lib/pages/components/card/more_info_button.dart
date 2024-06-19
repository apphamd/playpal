import 'package:flutter/material.dart';
import 'package:playpal/models/dog_model.dart';

class MoreInfoButton extends StatelessWidget {
  const MoreInfoButton({super.key, required this.dog});
  final DogModel dog;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Icon(
        Icons.info,
        color: Colors.white,
        size: 36,
      ),
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          builder: (BuildContext context) {
            return modalMenu(context);
          },
        );
      },
    );
  }

  Widget modalMenu(BuildContext context) {
    return Container(
      height: 400,
      color: Colors.white,
      child: Center(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(5.0),
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  iconSize: 35,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(
                  top: 16,
                ),
                child: const Text(
                  'more info',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                width: 340,
                padding: const EdgeInsets.only(
                  top: 60,
                  left: 10,
                ),
                // decoration: BoxDecoration(
                //   color: Colors.amber,
                // ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: const TextStyle(fontSize: 26),
                        children: [
                          TextSpan(
                            text: dog.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' is a '),
                          TextSpan(
                            text: '${dog.age} ${dog.ageTimespan}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' old '),
                          TextSpan(
                            text: '${dog.gender} ${dog.breed}.',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        style: const TextStyle(fontSize: 26),
                        children: [
                          TextSpan(
                              text:
                                  '${dog.gender == 'male' ? 'He' : 'She'} weighs '),
                          TextSpan(
                            text: '${dog.weight} lbs ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: 'and has a ',
                          ),
                          TextSpan(
                            text: '${dog.energyLevel} ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: 'energy level.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        style: const TextStyle(fontSize: 26),
                        children: [
                          TextSpan(
                              text: '${dog.gender == 'male' ? 'He' : 'She'} '),
                          TextSpan(
                            text:
                                '${dog.vaccinated ? 'is' : 'is NOT'} vaccinated, ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '${dog.fixed ? 'and' : 'but'} ',
                          ),
                          TextSpan(
                            text:
                                '${dog.fixed ? 'also' : 'not'} ${dog.gender == 'male' ? 'neutered' : 'spayed.'}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
