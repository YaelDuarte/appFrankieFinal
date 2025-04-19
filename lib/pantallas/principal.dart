import 'dart:math';

import 'package:flutter/material.dart';

class Principal extends StatefulWidget {
  const Principal({super.key, required this.title});
  final String title;

  @override
  State<Principal> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Principal> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter(){
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = max(50, 100 +(_counter * 10));
    double imageHeight = max(50, 75 + (_counter * 7));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(126, 2, 160, 350.0),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
                'https://media.istockphoto.com/id/1161334937/es/foto/guardabosques-gato-con-un-rifle-2.jpg?s=612x612&w=0&k=20&c=uxWXiX9ilXNfyKABDWdA4SB11ka5ciITtFe6RmgzL3s=',
              width: imageWidth,
              height: imageHeight,
            ),
            const SizedBox(height: 20),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),

          const SizedBox(width: 10),

          FloatingActionButton(
              onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
