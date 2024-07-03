import 'package:flutter/material.dart';
import 'package:test_project/screen_checkers.dart';
import 'package:test_project/screen_fields.dart';

class ScreenMenu extends StatefulWidget {
  const ScreenMenu({super.key});

  @override
  State<ScreenMenu> createState() => ScreenMenuState();
}

class ScreenMenuState extends State<ScreenMenu> {
  void onCheckersTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenCheckers(),
      ),
    );
  }

  void onFieldsTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenFields(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Выберите экран\nдля проведения тестирования',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: onCheckersTap,
              height: 50,
              minWidth: 250,
              color: Colors.deepPurple,
              child: Text(
                'Переключатели',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: onFieldsTap,
              color: Colors.deepPurple,
              height: 50,
              minWidth: 250,
              child: Text(
                'Поля',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
