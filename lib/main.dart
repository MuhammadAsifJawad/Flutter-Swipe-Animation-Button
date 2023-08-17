import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' show pi;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String swipeDirection = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller);

  }
  void animator(){
    _controller.repeat();
    Future.delayed(const Duration(seconds: 6), () {
      _controller.value = 0.0;
      _controller.stop();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Animation using Flutter', style: TextStyle(fontSize: 30,),),
      ),
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onVerticalDragEnd: (details) {
              // Calculate vertical swipe direction
              if (details.velocity.pixelsPerSecond.dy > 0) {
                setState(() {
                  swipeDirection = 'up';
                });
              } else {
                setState(() {
                  swipeDirection = 'down';
                });
              }
              animator();
              print(swipeDirection);
            },
            onHorizontalDragEnd: (details) {
              // Calculate horizontal swipe direction
              if (details.velocity.pixelsPerSecond.dx > 0) {
                setState(() {
                  swipeDirection = 'left';
                });
              } else {
                setState(() {
                  swipeDirection = 'right';
                });
              }
              animator();
              print(swipeDirection);
            },
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: swipeDirection=='left' || swipeDirection=='right'?(Matrix4.identity()..rotateY(_animation.value)):(Matrix4.identity()..rotateX(_animation.value)),
                  child: Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ]),
                      child: const Center(
                        child: Text(
                          'Swipe Me!',
                          style: TextStyle(color: Colors.white,fontSize: 40, fontWeight: FontWeight.bold,),
                        ),
                      )),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
