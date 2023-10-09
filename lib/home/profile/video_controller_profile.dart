import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../upload_video/video.dart';

class VideoControllerProfile extends GetxController
{
  final Rx<List<Video>> videoFileList = Rx<List<Video>>([]);
  List<Video> get clickedVideoFile => videoFileList.value;

  final Rx<String> _videoID = "".obs;
  String get clickedVideoID => _videoID.value;


  setVideoID(String vID)
  {
    _videoID.value = vID;
  }

  getClickedVideoInfo()
  {
    videoFileList.bindStream(
        FirebaseFirestore.instance
            .collection("videos")
            .snapshots()
            .map((QuerySnapshot snapshotQuery)
        {
          List<Video> videosList = [];

          for(var eachVideo in snapshotQuery.docs)
          {
            if(eachVideo["videoID"] == clickedVideoID)
            {
              videosList.add(
                  Video.fromDocumentSnapshot(eachVideo)
              );
            }
          }

          return videosList;
        })
    );
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getClickedVideoInfo();
  }

  likeOrUnlikeVideo(String videoID) async
  {
    var currentUserID = FirebaseAuth.instance.currentUser!.uid.toString();

    DocumentSnapshot snapshotDoc = await FirebaseFirestore.instance
        .collection("videos")
        .doc(videoID)
        .get();

    //if already Liked
    if((snapshotDoc.data() as dynamic)["likesList"].contains(currentUserID))
    {
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(videoID)
          .update(
          {
            "likesList": FieldValue.arrayRemove([currentUserID]),
          });
    }
    //if NOT-Liked
    else
    {
      await FirebaseFirestore.instance
          .collection("videos")
          .doc(videoID)
          .update(
          {
            "likesList": FieldValue.arrayUnion([currentUserID]),
          });
    }
  }
}