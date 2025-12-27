import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:tp_un/widgets/drawer.dart';
import 'package:tp_un/widgets/bottom_controls.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final player = AudioPlayer();

  Future<void> _play() async {
    await player.play(AssetSource('audio/vine-boom.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Center(
                child: Icon(
                  Icons.toys, // temporary fan icon
                  size: 160,
                  color: Colors.white,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF59556F),
                child: IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 32,
                  color: Colors.white,
                  onPressed: () async {
                    await _play();
                  },
                ),
              ),
            ),

            BottomControls(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
