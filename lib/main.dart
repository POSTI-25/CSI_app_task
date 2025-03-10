import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:process_run/process_run.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 121, 104, 152),
        appBar: AppBar(
          title: const Text(
            "YouTube Video Downloader",
            style: TextStyle(
              fontSize: 20, // Adjusts text size
              fontWeight: FontWeight.bold, // Makes text bold
              letterSpacing: 1.5, // Adds spacing between letters
              color: Colors.white,
            ),
          ),
          centerTitle: true, // Correctly placed
          backgroundColor: const Color.fromARGB(255, 92, 38, 118),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Input Field for YouTube Link
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                // text field
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ), 
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ), 
                    ),
                    hintText: "Paste YouTube URL Here",
                  ),
                ),
              ),
              const SizedBox(height: 20), // Spacer
              // Download Button
              SizedBox(
                width: 200, // Increases button width
                height: 50, // Increases button height
                child: ElevatedButton(
                  onPressed: () {
                    // Your download function
                  },
                  child: const Text(
                    "Download",
                    style: TextStyle(
                      fontSize: 20, // Increase text size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
