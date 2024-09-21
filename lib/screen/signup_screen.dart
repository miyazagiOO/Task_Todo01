import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text == _confirmPasswordController.text) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const SigninScreen()));
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Registration failed')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F3), // สีพื้นหลังชมพูพาสเทล
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 24, // ขนาดตัวอักษร
            fontWeight: FontWeight.bold, // ตัวหนา
          ),
        ),
        centerTitle: true, // จัดตำแหน่งข้อความตรงกลาง
        backgroundColor: const Color(0xFFF8BBD0), // สีแถบด้านบนชมพูพาสเทล
      ),
      body: Center(
        child: Container(
          width: 320, // กำหนดความกว้างให้เหมือนกัน
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white, // สีพื้นหลังของฟอร์ม
            borderRadius: BorderRadius.circular(20.0), // ขอบโค้ง
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // แรเงา
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'TODO',
                style: TextStyle(
                  fontSize: 40, // ขนาดตัวอักษรของ "TODO"
                  fontWeight: FontWeight.bold, // ตัวหนา
                  color: Color(0xFFEC407A), // สีของข้อความ (ชมพูเข้ม)
                ),
              ),
              const SizedBox(height: 20), // ระยะห่างระหว่าง "TODO" และฟอร์ม
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color(0xFFEC407A), // สีไอคอน (ชมพูเข้ม)
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your email' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFFEC407A), // สีไอคอน (ชมพูเข้ม)
                        ),
                      ),
                      obscureText: true,
                      validator: (value) => value!.length < 8
                          ? 'Password must be at least 8 characters'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFFEC407A), // สีไอคอน (ชมพูเข้ม)
                        ),
                      ),
                      obscureText: true,
                      validator: (value) => value!.isEmpty
                          ? 'Please confirm your password'
                          : null,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF48FB1), // สีปุ่มชมพูเข้ม
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), // ขอบปุ่มโค้ง
                        ),
                      ),
                      onPressed: _register,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18), // ขนาดตัวอักษรในปุ่ม
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
