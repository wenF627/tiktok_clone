import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/global.dart';
import 'package:tiktok_clone/home/home_screen.dart';

class ProfileController extends GetxController
{
  final Rx<Map<String, dynamic>> _userMap = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get userMap => _userMap.value;
  Rx<String> _userID = "".obs;

  updateCurrentUserID(String visitUserID)
  {
    _userID.value = visitUserID;

    retrieveUserInformation();
  }

  retrieveUserInformation() async
  {
    //get user info
    DocumentSnapshot userDocumentSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(_userID.value)
        .get();

    final userInfo = userDocumentSnapshot.data() as dynamic;

    String userName = userInfo["name"];
    String userEmail = userInfo["email"];
    String userImage = userInfo["image"];
    String userUID = userInfo["uid"];
    String userYoutube = userInfo["youtube"] == null ? "" : userInfo["youtube"];
    String userInstagram = userInfo["instagram"] == null ? "" : userInfo["instagram"];
    String userTwitter = userInfo["twitter"] == null ? "" : userInfo["twitter"];
    String userFacebook = userInfo["facebook"] == null ? "" : userInfo["facebook"];

    int totalLikes = 0;
    int totalFollowers = 0;
    int totalFollowings = 0;
    bool isFollowing = false;
    List<String> thumbnailsList = [];

    //get user's videos info
    var currentUserVideos = await FirebaseFirestore.instance
        .collection("videos")
        .orderBy("publishedDateTime", descending: true)
        .where("userID", isEqualTo: _userID.value)
        .get();

    for(int i=0; i<currentUserVideos.docs.length; i++)
    {
      thumbnailsList.add((currentUserVideos.docs[i].data() as dynamic)["thumbnailUrl"]);
    }

    //get total number of likes
    for(var eachVideo in currentUserVideos.docs)
    {
      totalLikes = totalLikes + (eachVideo.data()["likesList"] as List).length;
    }

    //get the total number of followers
    var followersNumDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(_userID.value).collection("followers")
        .get();
    totalFollowers = followersNumDocument.docs.length;

    //get the total number of followings
    var followingsNumDocument = await FirebaseFirestore.instance
        .collection("users")
        .doc(_userID.value).collection("following")
        .get();
    totalFollowings = followingsNumDocument.docs.length;

    //get the isFollowing true or false value
    //check if online currentUserID exists inside the followers List of visited profilePerson
    FirebaseFirestore.instance
        .collection("users").doc(_userID.value)
        .collection("followers").doc(currentUserID)
        .get().then((value)
    {
      if(value.exists)
      {
        isFollowing = true;
      }
      else
      {
        isFollowing = false;
      }
    });

    _userMap.value =
    {
      "userName": userName,
      "userEmail": userEmail,
      "userImage": userImage,
      "userUID": userUID,
      "userYoutube": userYoutube,
      "userInstagram": userInstagram,
      "userTwitter": userTwitter,
      "userFacebook": userFacebook,
      "totalLikes": totalLikes.toString(),
      "totalFollowers": totalFollowers.toString(),
      "totalFollowings": totalFollowings.toString(),
      "isFollowing": isFollowing,
      "thumbnailsList": thumbnailsList,
    };

    update();
  }

  followUnFollowUser() async
  {
    //1. currentUser = already logged-in online user
    //2. other user = [visitor's profile]

    var document = await FirebaseFirestore.instance
        .collection("users").doc(_userID.value)
        .collection("followers").doc(currentUserID)
        .get();

    //currentUser is Already following other user [visitor's profile]
    if(document.exists)
    {
      //remove follower
      //remove following

      //1. remove currentUser as a follower from visitorPerson's followersList
      await FirebaseFirestore.instance
          .collection("users").doc(_userID.value)
          .collection("followers").doc(currentUserID)
          .delete();

      //2. remove that visitorProfile's person from the current user's followingList
      await FirebaseFirestore.instance
          .collection("users").doc(currentUserID)
          .collection("following").doc(_userID.value)
          .delete();

      //decrement - update totalFollowers number
      _userMap.value.update("totalFollowers", (value)=> (int.parse(value) - 1).toString());
    }
    //if currentUser is NOT Already following the other user [visitor's profile]
    else
    {
      //add new follower
      //add new following

      //1. add currentUser as a new follower to visitor's followersList
      await FirebaseFirestore.instance
          .collection("users").doc(_userID.value)
          .collection("followers").doc(currentUserID)
          .set({});

      //2. add that visitProfile person as a new following to the current user's followingList
      await FirebaseFirestore.instance
          .collection("users").doc(currentUserID)
          .collection("following").doc(_userID.value)
          .set({});

      //increment - update totalFollowers number
      _userMap.value.update("totalFollowers", (value)=> (int.parse(value) + 1).toString());
    }

    _userMap.value.update("isFollowing", (value)=> !value);

    update();
  }

  updateUserSocialAccountLinks(String facebook, String youtube, String twitter, String instagram) async
  {
    try
    {
      final Map<String, dynamic> userSocialLinksMap =
      {
        "facebook": facebook,
        "youtube": youtube,
        "twitter": twitter,
        "instagram": instagram,
      };

      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID)
          .update(userSocialLinksMap);

      Get.snackbar("Social Links", "your social links are updated successfully.");

      Get.to(HomeScreen());
    }
    catch(errorMsg)
    {
      Get.snackbar("Error Updating Account", "Please try again.");
    }
  }
}