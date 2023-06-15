import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';

class IntroFull extends StatefulWidget {
  const IntroFull({Key? key}) : super(key: key);

  @override
  State<IntroFull> createState() => _IntroFullState();
}

class _IntroFullState extends State<IntroFull> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    if (Get.currentRoute == '/') {
      _videoPlayerController =
          VideoPlayerController.asset('assets/anim/IntroMetalico.mp4');
      _initializeVideoPlayer();
    }
  }

  Future<void> _initializeVideoPlayer() async {
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      showControls: false,
    );
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.position ==
          _videoPlayerController.value.duration) {
        // El video ha llegado al final, navegar a la siguiente pantalla
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    setState(() {
      _isVideoInitialized = true;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVideoInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}  // late VideoPlayerController _videoPlayerController;
  // late Future<void> _initializeVideoPlayerFuture;

  // @override
  // void initState() {
  //   super.initState();
  //   _videoPlayerController =
  //       VideoPlayerController.asset('assets/anim/IntroMetalico.mp4');
  //   _initializeVideoPlayerFuture = _videoPlayerController.initialize();
  //   _videoPlayerController.play();

  //   _videoPlayerController.addListener(() {
  //     if (_videoPlayerController.value.position ==
  //         _videoPlayerController.value.duration) {
  //       // El video ha llegado al final, navegar a la siguiente pantalla
  //       Navigator.pushReplacementNamed(context, "/login");
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   _videoPlayerController.dispose();
  //   super.dispose();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //     future: _initializeVideoPlayerFuture,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         return AspectRatio(
  //           aspectRatio: _videoPlayerController.value.aspectRatio,

  //           child: VideoPlayer(_videoPlayerController),
  //         );
  //       } else {
  //         return const CircularProgressIndicator();
  //       }
  //     },
  //   );
  // }
