import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScreenFields extends StatefulWidget {
  const ScreenFields({super.key});

  @override
  State<ScreenFields> createState() => ScreenFieldsState();
}

class ScreenFieldsState extends State<ScreenFields> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  bool isCheckDone = false;

  bool isCheckEnabled() {
    return controller1.text == 'test' &&
        controller2.text.isEmpty &&
        controller3.text.length > 5;
  }

  void onCheckTap() {
    isCheckDone = true;
    setState(() {});
  }

  void onTextChanged(String newValue) {
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
              'Поля',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Кнопка должна быть доступна\nтолько если\nв первом поле слово "test"\nвторое поле пусто\nв третьем поле больше 5 символов',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            buildField1(),
            buildField2(),
            buildField3(),
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

  Widget buildField1() {
    return SizedBox(
      width: 250,
      child: TextField(
        key: Key('field1'),
        controller: controller1,
        onChanged: onTextChanged,
      ),
    );
  }

  Widget buildField2() {
    return SizedBox(
      width: 250,
      child: TextField(
        key: Key('field2'),
        controller: controller2,
        onChanged: onTextChanged,
      ),
    );
  }

  Widget buildField3() {
    return SizedBox(
      width: 250,
      child: TextField(
        key: Key('field3'),
        controller: controller3,
        onChanged: onTextChanged,
      ),
    );
  }
}
