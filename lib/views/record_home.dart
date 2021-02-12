import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

enum RecordingState { Unset, Set, Recording, Stopped }

class RecordScreen extends StatefulWidget {
  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  // stt.SpeechToText _speech;
  // bool _isListening = false;
  String _text = 'Press the button and start speaking';

  // double _confindence = 1.0;
  Directory appDirectory;
  Stream<FileSystemEntity> fileStream;
  List<String> records;
  RecordingState _recordingState = RecordingState.Unset;
  String filePath;

  FlutterAudioRecorder audioRecorder;

  @override
  void initState() {
    super.initState();
    // _speech = stt.SpeechToText();

    // records = [];
    getExternalStorageDirectory().then((value) {
      print(value);
      appDirectory = value;
      setState(() {});
    });
    // getApplicationDocumentsDirectory().then((value) {
    //   appDirectory = value;
    //   setState(() {});
    // });

    // getApplicationDocumentsDirectory().then((value) {
    //   appDirectory = value;
    //   appDirectory.list().listen((onData) {
    //     records.add(onData.path);
    //   }).onDone(() {
    //     records = records.reversed.toList()
    //     setState(() {});
    //   });
    // });
    FlutterAudioRecorder.hasPermissions.then((hasPermission) {
      if (hasPermission) {
        _recordingState = RecordingState.Set;
      }
    });
  }

  @override
  void dispose() {
    // fileStream = null;
    // appDirectory = null;
    // records = null;
    _recordingState = RecordingState.Unset;
    audioRecorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('voice')
        // Text('Confidence : ${(_confindence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _recordingState == RecordingState.Recording,
        glowColor: Theme
            .of(context)
            .primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: () async {
            await _record();
            setState(() {});
          },
          child: Icon(_recordingState == RecordingState.Recording
              ? Icons.mic
              : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
            padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
            child: Text(_text)
          // child: TextHighlight(
          //   text: (_text.length < 1) ? '' : _text,
          //   // at least must be empty string ''
          //   words: _highlights,
          //   textStyle: const TextStyle(
          //     fontSize: 32.0,
          //     color: Colors.black,
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
        ),
      ),
    );
  }

  void _record() async {
    switch (_recordingState) {
      case RecordingState.Set:
        await _recordVoice();
        break;
      case RecordingState.Recording:
        await _stopRecording();
        _recordingState = RecordingState.Stopped;
        break;
      case RecordingState.Stopped:
        await _recordVoice();
        break;
      case RecordingState.Unset:
        askPermission();
        break;
    }
    // if (!_isListening) {
    //   bool available = await _speech.initialize(
    //     onStatus: (val) => print('OnStatus: $val'),
    //     onError: (val) => print('OnError: $val'),
    //     debugLogging: true,
    //   );
    //   if (available) {
    //     setState(() => _isListening = true);
    //     _speech.listen(
    //       onResult: (val) => setState(() {
    //         _text = val.recognizedWords;
    //         print(_text);
    //
    //         if (val.hasConfidenceRating && val.confidence > 0) {
    //           //package somes return confidence 0
    //           _confindence = val.confidence;
    //         }
    //       }),
    //     );
    //   }
    // } else {
    //   print('stopped');
    //   setState(() => _isListening = false);
    //   _speech.stop();
    // }
  }

  void askPermission() {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Please allow recording from settings'),
    ));
  }

  _initRecorder() async {
    // Directory appDirectory = await getApplicationDocumentsDirectory();
    filePath = appDirectory.path +
        '/anxi_pro' +
        DateTime
            .now()
            .millisecondsSinceEpoch
            .toString() +
        '.aac';
    audioRecorder =
        FlutterAudioRecorder(filePath, audioFormat: AudioFormat.AAC);
    await audioRecorder.initialized;
  }

  _startRecording() async {
    await audioRecorder.start();
  }

  _stopRecording() async {
    await audioRecorder.stop();
    _text = filePath;
  }

  Future<void> _recordVoice() async {
    if (await FlutterAudioRecorder.hasPermissions) {
      await _initRecorder();

      await _startRecording();
      _recordingState = RecordingState.Recording;
    } else {
      askPermission();
    }
  }
}
