import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> login() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'http://192.168.254.193/login.php'); // 
    final response = await http.post(url, body: {
      'email': _emailController.text,
      'password': _passwordController.text,
    });

    setState(() {
      _isLoading = false;
    });

    final result = json.decode(response.body);
    if (result['success']) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(userId: result['user_id']),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: login,
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}

class Dashboard extends StatefulWidget {
  final int userId;

  Dashboard({required this.userId});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _infoController = TextEditingController();
  List<String> _infoList = [];
  bool _isLoading = false;

  Future<void> addInfo() async {
    final url = Uri.parse(
        'http://192.168.254.193/add_info.php'); 
    final response = await http.post(url, body: {
      'user_id': widget.userId.toString(),
      'info': _infoController.text,
    });

    final result = json.decode(response.body);
    if (result['success']) {
      fetchInfo();
      _infoController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add info.')),
      );
    }
  }

  Future<void> fetchInfo() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'http://192.168.254.193/get_info.php?user_id=${widget.userId}'); // 
    final response = await http.get(url);

    setState(() {
      _isLoading = false;
    });

    final result = json.decode(response.body);
    if (result['success']) {
      setState(() {
        _infoList =
            List<String>.from(result['data'].map((item) => item['info']));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch info.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _infoController,
              decoration: InputDecoration(labelText: 'Enter Info'),
            ),
            ElevatedButton(
              onPressed: addInfo,
              child: Text('Add Info'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _infoList.length,
                      itemBuilder: (context, index) {
                        return ListTile(title: Text(_infoList[index]));
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
