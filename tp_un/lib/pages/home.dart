import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tp_un/widgets/drawer.dart';
import 'package:tp_un/widgets/bottom_controls.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final player = AudioPlayer();

  String _currentAudio = "";
  bool _isPlaying = false;

  void _onFanSelected(String audioPath) {
    setState(() {
      _currentAudio = audioPath;
    });
  }

  Future<void> _play() async {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    await player.stop();

    if (_isPlaying) {
      await AudioPlayer.clearAssetCache();
      await player.setLoopMode(LoopMode.one);
      await player.setAsset(_currentAudio);
      await player.play();
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
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
                  icon: _isPlaying
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                  iconSize: 32,
                  color: Colors.white,
                  onPressed: () async {
                    await _play();
                  },
                ),
              ),
            ),

            BottomControls(onFanSelected: _onFanSelected),
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
