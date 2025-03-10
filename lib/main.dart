import 'package:flutter/material.dart';
import 'dart:io';
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
      home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _myController =
      TextEditingController(); // Step 1: Creatint texteditig Controller
      // String _downloadStatus = "Eneter URL....";
      Future<void> _downloadVideo() async {
    String youtubeUrl = _myController.text.trim(); // Get input URL

    if (youtubeUrl.isEmpty) return; // Do nothing if empty

    // Run yt-dlp command
    ProcessResult result = await Process.run(
      'yt-dlp',
      [youtubeUrl], // Basic download
      runInShell: true, // Needed for Windows
    );

    print("Download Output: ${result.stdout}");
    print("Error (if any): ${result.stderr}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input Field for YouTube Link
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              // text field
              child: TextField(
                controller: _myController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
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
                onPressed: _downloadVideo,
                  // Yt download function
                  // String youtubeUrl = _myController.text;
                  // print("URL: $youtubeUrl");
                // },
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
    );
  }
}
