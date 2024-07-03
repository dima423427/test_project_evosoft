import 'package:flutter/material.dart';

class ScreenCheckers extends StatefulWidget {
  const ScreenCheckers({super.key});

  @override
  State<ScreenCheckers> createState() => ScreenCheckersState();
}

class ScreenCheckersState extends State<ScreenCheckers> {
  bool isSwitch1IsOn = false;
  bool isSwitch2IsOn = false;
  bool isSwitch3IsOn = false;
  bool isCheckDone = false;

  bool isCheckEnabled() {
    return isSwitch1IsOn && !isSwitch2IsOn && isSwitch3IsOn;
  }

  void onCheckTap() {
    isCheckDone = true;
    setState(() {});
  }

  void onSwitch1Tap(bool newValue) {
    isSwitch1IsOn = newValue;
    setState(() {});
  }

  void onSwitch2Tap(bool newValue) {
    isSwitch2IsOn = newValue;
    setState(() {});
  }

  void onSwitch3Tap(bool newValue) {
    isSwitch3IsOn = newValue;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Переключатели',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Кнопка должна быть доступна\nтолько если включены 1 и 3 переключатели',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            buildSwitch1(),
            buildSwitch2(),
            buildSwitch3(),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: isCheckEnabled() ? onCheckTap : null,
              color: Colors.deepPurple,
              disabledColor: Colors.black26,
              height: 50,
              minWidth: 250,
              child: Text(
                'Проверка',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 20),
            if (isCheckDone)
              Text(
                'Проверка пройдена',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildSwitch1() {
    return SizedBox(
      width: 250,
      child: Row(
        children: [
          Switch(
            key: Key('swithc1'),
            value: isSwitch1IsOn,
            onChanged: onSwitch1Tap,
          ),
          SizedBox(width: 10),
          Text('Переключатель 1'),
        ],
      ),
    );
  }

  Widget buildSwitch2() {
    return SizedBox(
      width: 250,
      child: Row(
        children: [
          Switch(
            key: Key('swithc2'),
            value: isSwitch2IsOn,
            onChanged: onSwitch2Tap,
          ),
          SizedBox(width: 10),
          Text('Переключатель 2'),
        ],
      ),
    );
  }

  Widget buildSwitch3() {
    return SizedBox(
      width: 250,
      child: Row(
        children: [
          Switch(
            key: Key('swithc3'),
            value: isSwitch3IsOn,
            onChanged: onSwitch3Tap,
          ),
          SizedBox(width: 10),
          Text('Переключатель 3'),
        ],
      ),
    );
  }
}
