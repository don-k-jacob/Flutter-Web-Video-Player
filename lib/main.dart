import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

void main() => runApp(VideoApp());

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;
  double volume = 0.5;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (_controller.value.initialized)
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                padding: EdgeInsets.all(10),
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(_controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow),
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                  ),
                  Text(
                      '${convertToMin(_controller.value.position)}/${convertToMin(_controller.value.duration)}'),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(animatedvol(volume)),
                  Slider(
                      max: 1,
                      min: 0,
                      value: volume,
                      onChanged: (_volume) {
                        setState(() {
                          volume = _volume;
                          _controller.setVolume(_volume);
                        });
                      }),
                  Spacer(),
                  IconButton(icon: Icon(Icons.loop), color: _controller.value.isLooping?Colors.green:Colors.grey, onPressed: (){
                    _controller.setLooping(!_controller.value.isLooping);
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

String convertToMin(Duration duration) {
  final min =
      duration.inMinutes < 10 ? '0${duration.inMinutes}' : duration.inMinutes;
  final sec =
      duration.inSeconds < 10 ? '0${duration.inSeconds}' : duration.inSeconds;
  return '$min:$sec';
}

IconData animatedvol(double volume) {
  if (volume == 0)
    return Icons.volume_mute;
  else if (volume <= 0.5)
    return Icons.volume_down;
  else
    return Icons.volume_up;
}
