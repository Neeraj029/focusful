import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pod_player/pod_player.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class video_screen extends StatefulWidget {
  final String videoId;
  const video_screen({Key? key, required this.videoId}) : super(key: key);

  @override
  State<video_screen> createState() => _video_screenState();
}

class _video_screenState extends State<video_screen> {
  late final PodPlayerController controller;

  @override
  void initState() {
    controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.youtube(
          'https://youtu.be/${widget.videoId}',
        ),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: false,
          isLooping: false,
          videoQualityPriority: [1080, 720],
        ))
      ..initialise();
    super.initState();
  }

  // if full screen is enabled, then disable it after clicking back button and if it is already disabled, return back to home screen
  Future<bool> _onWillPop() async {
    if (controller.isFullScreen) {
      controller.disableFullScreen(context);
      return false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // YoutubePlayerController _controller = YoutubePlayerController(
    //   initialVideoId: widget.videoId,
    //   flags: YoutubePlayerFlags(
    //     autoPlay: false,
    //     mute: false,
    //   ),
    // );
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "watching_video");
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: MaterialApp(
        title: 'PP Edtech',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            backgroundColor: Colors.black38,
            body: SafeArea(
              child: Center(
                child: PodVideoPlayer(controller: controller),
              ),
            )),
      ),
    );
  }
}
