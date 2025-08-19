import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Factory Monitor',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Color(0xFF003087),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text('GZ',
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = '';
  String _password = '';
  String _deviceId = '';
  List<String> allowedDevices = ['device-id-sample1'];

  Future<void> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      var iosInfo = await deviceInfo.iosInfo;
      _deviceId = iosInfo.identifierForVendor ?? '';
    } else {
      var androidInfo = await deviceInfo.androidInfo;
      _deviceId = androidInfo.id;
    }
  }

  Future<void> _login() async {
    await _getDeviceId();
    if (!allowedDevices.contains(_deviceId)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('دستگاه مجاز نیست')));
      return;
    }
    if (_username == 'admin' && _password == '123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ShiftsPage()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('نام کاربری یا رمز اشتباه است')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ورود')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) => _username = value,
              decoration: InputDecoration(labelText: 'نام کاربری'),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) => _password = value,
              obscureText: true,
              decoration: InputDecoration(labelText: 'رمز عبور'),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _login, child: Text('ورود')),
          ],
        ),
      ),
    );
  }
}

class ShiftsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('شیفت‌های کارخانه گندله‌سازی')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Gz.PNG'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShiftButton(shift: 'شیفت A'),
              ShiftButton(shift: 'شیفت B'),
              ShiftButton(shift: 'شیفت C'),
              ShiftButton(shift: 'شیفت D'),
            ],
          ),
        ),
      ),
    );
  }
}

class ShiftButton extends StatelessWidget {
  final String shift;

  ShiftButton({required this.shift});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(shift, style: TextStyle(fontSize: 20)),
        style: ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
      ),
    );
  }
}
