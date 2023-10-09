import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../upload_video/video.dart';

class ControllerForYouVideos extends GetxController
{
  final Rx<List<Video>> forYouVideosList = Rx<List<Video>>([]);
  List<Video> get forYouAllVideosList => forYouVideosList.value;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    forYouVideosList.bindStream(
      FirebaseFirestore.instance
          .collection("videos")
          .orderBy("totalComments", descending: true)
          .snapshots()
          .map((QuerySnapshot snapshotQuery)
      {
        List<Video> videosList = [];

        for(var eachVideo in snapshotQuery.docs)
        {
          videosList.add(
            Video.fromDocumentSnapshot(eachVideo)
          );
        }

        return videosList;
      })
    );
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