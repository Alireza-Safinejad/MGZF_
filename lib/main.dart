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
        MaterialPageRoute(builder: (_) => LoginPage()),
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
            child: Text(
              'GZ',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
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
    var info = await deviceInfo.androidInfo;
    _deviceId = info.id;
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
        MaterialPageRoute(builder: (_) => ShiftsPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('نام کاربری یا رمز اشتباه است')));
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
              onChanged: (v) => _username = v,
              decoration: InputDecoration(labelText: 'نام کاربری'),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (v) => _password = v,
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
      appBar: AppBar(title: Text('شیفت‌ها')),
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
            children: ['A', 'B', 'C', 'D']
                .map(
                  (s) => Padding(
                    padding: EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ShiftDetailsPage(shift: s),
                          ),
                        );
                      },
                      child: Text('شیفت $s'),
                      style:
                          ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class ShiftDetailsPage extends StatelessWidget {
  final String shift;
  ShiftDetailsPage({required this.shift});

  final Map<String, dynamic> mockData = {
    'آلارم‌ها': 'آلارم سنسور 1',
    'توقفات': '2 ساعت',
    'رطوبت': '8%',
    'FeO': '12%',
    'بلین': '3500',
    'تولید/ساعت': '500 تن',
    'ریجکت': '2.1%',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('جزئیات شیفت $shift')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: mockData.entries
            .map((e) => Card(
                  child: ListTile(
                    title: Text(e.key),
                    subtitle: Text(e.value.toString()),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
