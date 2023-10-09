import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_clone/home/comments/comments_screen.dart';
import 'package:tiktok_clone/home/for_you/controller_for_you_videos.dart';
import 'package:tiktok_clone/home/profile/video_controller_profile.dart';
import 'package:tiktok_clone/widgets/circular_image_animation.dart';
import 'package:tiktok_clone/widgets/custom_video_player.dart';

class VideoPlayerProfile extends StatefulWidget
{
  String clickedVideoID;

  VideoPlayerProfile({required this.clickedVideoID,});

  @override
  State<VideoPlayerProfile> createState() => _VideoPlayerProfileState();
}



class _VideoPlayerProfileState extends State<VideoPlayerProfile>
{
  final VideoControllerProfile controllerVideoProfile = Get.put(VideoControllerProfile());

  @override
  Widget build(BuildContext context)
  {
    controllerVideoProfile.setVideoID(widget.clickedVideoID.toString());

    return Scaffold(
      body: Obx(()
      {
        return PageView.builder(
          itemCount: controllerVideoProfile.clickedVideoFile.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index)
          {
            final clickedVideoInfo = controllerVideoProfile.clickedVideoFile[index];

            return Stack(
              children: [

                //video
                CustomVideoPlayer(
                  videoFileUrl: clickedVideoInfo.videoUrl.toString(),
                ),

                //left right - panels
                Column(
                  children: [

                    const SizedBox(
                      height: 110,
                    ),

                    //left right - panels
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [

                          //left panel
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 18),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  //username
                                  Text(
                                    "@" + clickedVideoInfo.userName.toString(),
                                    style: GoogleFonts.abel(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 6,
                                  ),

                                  //description - tags
                                  Text(
                                    clickedVideoInfo.descriptionTags.toString(),
                                    style: GoogleFonts.abel(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 6,
                                  ),

                                  //artist - song name
                                  Row(
                                    children: [
                                      Image.asset(
                                        "images/music_note.png",
                                        width: 20,
                                        color: Colors.white,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "  " + clickedVideoInfo.artistSongName.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.alexBrush(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),

                          //right panel
                          Container(
                            width: 100,
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                //profile
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SizedBox(
                                    width: 62,
                                    height: 62,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 4,
                                          child: Container(
                                            width: 52,
                                            height: 52,
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(25),
                                              child: Image(
                                                image: NetworkImage(
                                                  clickedVideoInfo.userProfileImage.toString(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                //like button - total Likes
                                Column(
                                  children: [
                                    //like button
                                    IconButton(
                                      onPressed: ()
                                      {
                                        controllerVideoProfile.likeOrUnlikeVideo(clickedVideoInfo.videoID.toString());
                                      },
                                      icon: Icon(
                                        Icons.favorite_rounded,
                                        size: 40,
                                        color: clickedVideoInfo.likesList!.contains(FirebaseAuth.instance.currentUser!.uid)
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                    ),

                                    //total Likes
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        clickedVideoInfo.likesList!.length.toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                //comment button - total comments
                                Column(
                                  children: [
                                    //comment button
                                    IconButton(
                                      onPressed: ()
                                      {
                                        Get.to(CommentsScreen(
                                          videoID: clickedVideoInfo.videoID.toString(),
                                        ));
                                      },
                                      icon: const Icon(
                                        Icons.add_comment,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),

                                    //total comments
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        clickedVideoInfo.totalComments.toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                //share button - total shares
                                Column(
                                  children: [
                                    //share button
                                    IconButton(
                                      onPressed: ()
                                      {

                                      },
                                      icon: const Icon(
                                        Icons.share,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),

                                    //total shares
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        clickedVideoInfo.totalShares.toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                //profile circular animation
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CircularImageAnimation(
                                    widgetAnimation: SizedBox(
                                      width: 62,
                                      height: 62,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            height: 52,
                                            width: 52,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                  colors:
                                                  [
                                                    Colors.grey,
                                                    Colors.white,
                                                  ]
                                              ),
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(25),
                                              child: Image(
                                                image: NetworkImage(
                                                  clickedVideoInfo.userProfileImage.toString(),
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),

                  ],
                ),

              ],
            );
          },
        );
      }),
    );
  }
}
