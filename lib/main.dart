import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// import 'package:process_run/process_run.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
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

  String _downloadStatus = "Eneter URL....";

  Future<void> _downloadVideo() async {
    String youtubeUrl = _myController.text.trim(); // Get input URL

    if (youtubeUrl.isEmpty) return; // Do nothing if empty

    String userHome =
        Platform.environment['USERPROFILE'] ?? "C:\\Users\\Default";
    // Define the new folder path inside the user's home directory
    String newFolderPath = "$userHome\\YouTube_Downloads";
    Directory newFolder = Directory(newFolderPath);
    if (!newFolder.existsSync()) {
      newFolder.createSync(recursive: true); // Creates the folder automatically
      print("Created folder: $newFolderPath");
    }
    String savePath = "$newFolderPath\\%(title)s.%(ext)s";

    setState(() {
      _downloadStatus =
          "Downloading..."; // ✅ NEW: Show "Downloading..." message
    });

    Process.start(
      'yt-dlp',
      ['-o', savePath, youtubeUrl], // -o specifies output location
    ).then((process) {
      process.stdout.transform(SystemEncoding().decoder).listen((data) {
        setState(() {
          _downloadStatus = data; // ✅ NEW: Live update progress
        });
      });

      // print("Download Complete: ${result.stdout}");
      // print("Errors (if any): ${result.stderr}");

      process.exitCode.then((exitCode) {
        setState(() {
          _downloadStatus =
              exitCode == 0 ? "✅ Download Complete!" : "❌ Download Failed!";
        });
      });
    });
  }
  //     if (result.exitCode == 0) {
  //       print("✅ Download Complete: ${result.stdout}");
  //     } else {
  //       print("❌ Download Failed: ${result.stderr}");
  //     }
  //   });
  // }

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

            const SizedBox(height: 20),
            Text(
              // ✅ NEW: Display download status
              _downloadStatus,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
