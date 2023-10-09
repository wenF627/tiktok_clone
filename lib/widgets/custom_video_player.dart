import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget
{
  final String videoFileUrl;

  CustomVideoPlayer({required this.videoFileUrl,});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}


class _CustomVideoPlayerState extends State<CustomVideoPlayer>
{
  VideoPlayerController? playerController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    playerController = VideoPlayerController.network(widget.videoFileUrl)
    ..initialize().then((value)
    {
      playerController!.play();
      playerController!.setLooping(false);
      playerController!.setVolume(2);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: VideoPlayer(
        playerController!
      ),
    );
  }
}
