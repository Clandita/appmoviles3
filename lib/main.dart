import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:appmoviles3/pages/home.dart'; // Asegúrate de importar correctamente tu página Home

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late UserCredential _userCredential;
  late String _email;
  late String _password;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _signInWithEmailAndPassword() async {
    _email = _emailController.text;
    _password = _passwordController.text;

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      setState(() {
        _userCredential = userCredential;
        _showError = false;
      });

      _navigateToHomePage();

    } on FirebaseAuthException catch (e) {
      setState(() {
        _showError = true;
        if (e.code == 'user-not-found') {
          _errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          _errorMessage = 'Wrong password provided for that user.';
        } else {
          _errorMessage = 'Error:Credenciales invalidas';
        }
      });
    } catch (e) {
      setState(() {
        _showError = true;
        _errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        _userCredential = userCredential;
        _showError = false; 
      });

      _navigateToHomePage();

    } catch (e) {
      setState(() {
        _showError = true;
        _errorMessage = 'Error al iniciar sesión con Google';
      });
    }
  }

  void _navigateToHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffbd2cc),
      appBar: AppBar(
        backgroundColor: Color(0xfffbd2cc),
        centerTitle: true,
        title: const Text('Login',style: TextStyle(fontSize: 40),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 200, 
                backgroundImage: AssetImage('assets/img/logo.png'),
                backgroundColor: Colors.transparent,
              ),
              
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  fillColor: Colors.white,
                  filled: true,
                  
                  ),
              ),
              SizedBox(height: 16.0,),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password',fillColor: Colors.white,
                  filled: true,),
                obscureText: true,
              ),
              if (_showError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signInWithEmailAndPassword,
                child: const Text('Login with Email'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signInWithGoogle,
                child: const Text('Login with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
