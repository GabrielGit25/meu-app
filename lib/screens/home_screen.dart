import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/audio_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _audioService = AudioService();
  List<PlatformFile> _files = [];
  String? _currentName;
  bool _isPlaying = false;

  Future<void> _pickFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        _files = result.files;
      });
    }
  }

  Future<void> _play(PlatformFile file) async {
    if (file.path == null) return;
    await _audioService.play(file.path!);
    setState(() {
      _currentName = file.name;
      _isPlaying = true;
    });
  }

  Future<void> _pause() async {
    await _audioService.pause();
    setState(() => _isPlaying = false);
  }

  Future<void> _resume() async {
    await _audioService.resume();
    setState(() => _isPlaying = true);
  }

  Future<void> _stop() async {
    await _audioService.stop();
    setState(() {
      _currentName = null;
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MP3 Player'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _pickFiles,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Colors.indigo.shade900,
            child: Column(
              children: [
                const Icon(Icons.music_note, size: 64),
                const SizedBox(height: 16),
                Text(
                  _currentName ?? 'Nenhuma música selecionada',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 48,
                      icon: Icon(
                        _isPlaying ? Icons.pause_circle : Icons.play_circle,
                      ),
                      onPressed: _currentName == null
                          ? null
                          : (_isPlaying ? _pause : _resume),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      iconSize: 48,
                      icon: const Icon(Icons.stop_circle),
                      onPressed: _currentName == null ? null : _stop,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _files.isEmpty
                ? const Center(
                    child: Text(
                      'Toque em + para adicionar músicas',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _files.length,
                    itemBuilder: (context, index) {
                      final file = _files[index];
                      final isCurrent = file.name == _currentName;
                      return ListTile(
                        leading: Icon(
                          isCurrent ? Icons.music_note : Icons.audiotrack,
                          color: isCurrent ? Colors.indigo : Colors.grey,
                        ),
                        title: Text(
                          file.name,
                          style: TextStyle(
                            color: isCurrent ? Colors.indigo : Colors.white,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () => _play(file),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
