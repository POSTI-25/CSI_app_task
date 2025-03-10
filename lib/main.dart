import 'package:flutter/material.dart';
import 'dart:io';

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
  final TextEditingController _myController = TextEditingController();  // creating text editng controler

  String _downloadStatus = "Enter URL....";
  double _progress = 0.0;
  String _downloadMessage = ""; // Message for file path

  Future<void> _downloadVideo() async {
    String youtubeUrl = _myController.text.trim();  // Get input URL
    if (youtubeUrl.isEmpty) return;

    String userHome =
        Platform.environment['USERPROFILE'] ?? "C:\\Users\\Default";
    String newFolderPath = "$userHome\\YouTube_Downloads";
    Directory newFolder = Directory(newFolderPath);
    if (!newFolder.existsSync()) {
      newFolder.createSync(recursive: true);
      print("Created folder: $newFolderPath");
    }
    String savePath = "$newFolderPath\\%(title)s.%(ext)s";

    setState(() {
      _downloadStatus = "Downloading...";
      _progress = 0.0;  // Reset progress at start
      _downloadMessage = ""; // Reset message on new download
    });

    Process.start('yt-dlp', ['-o', savePath, youtubeUrl, "--progress"]).then((
      process,
    ) {
      process.stdout.transform(SystemEncoding().decoder).listen((data) {
        RegExp regex = RegExp(r'(\d+)%');  // Extract percentage
        Match? match = regex.firstMatch(data);
        if (match != null) {
          double percent = double.parse(match.group(1)!) / 100.0;
          setState(() {
            _progress = percent;
            _downloadStatus =
                "Downloading... ${(percent * 100).toStringAsFixed(0)}%";
          });
        }
      });

      process.exitCode.then((exitCode) {
        setState(() {
          _progress = exitCode == 0 ? 1.0 : 0.0;
          _downloadStatus =
              exitCode == 0 ? "Download Complete!" : "Download Failed!";
          if (exitCode == 0) {
            _downloadMessage =
                "Video saved in: $newFolderPath"; // Show file path
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 179, 117, 179),
      appBar: AppBar(
        title: const Text(
          "YouTube Video Downloader",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 92, 38, 118),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
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
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: _downloadVideo,
                child: const Text(
                  "Download",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Progress Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: _progress,  //  Dynamic progress value
                    backgroundColor: Colors.grey,
                    color: Colors.green,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _downloadStatus,  // download percentage
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Show Download Path
            if (_downloadMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  _downloadMessage, 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
