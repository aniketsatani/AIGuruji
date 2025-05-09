import 'package:aiguruji/Constant/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Api {
  final CollectionReference Users = FirebaseFirestore.instance.collection('User');
  final CollectionReference AIGuruji = FirebaseFirestore.instance.collection('AIGuruji');

  /// Check User Exists Yes or No
  Future<bool> checkUserExists() async {
    try {
      DocumentSnapshot doc = await Users.doc(userId).get();
      if (doc.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Add UserData
  Future addUserData({required UserModel userModel}) async {
    await Users.doc(userId).set(userModel.toMap());
  }

  /// Update UserData
  Future updateUserData({required String image}) async {
    await Users.doc(userId).update({'image': image, 'imageType': 'asset'});
  }

  /// Get Userid wise Data
  Future getUser() async {
    DocumentSnapshot doc = await Users.doc(userId).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      userId = data['id'] ?? '';
      name.value = data['name'] ?? '';
      email.value = data['email'] ?? '';
      image.value = data['image'] ?? '';
    }
  }

  /// Delete userId
  Future deleteUserAccount({required String userId}) async {
    try {
      await Users.doc(userId).delete();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {}
  }



  /// get PixelWalls data
  Future getAIGurujiData() async {
    /// AIGurujiAPI
    DocumentSnapshot api = await AIGuruji.doc('AIGurujiAPI').get();
    if (api.exists) {
      Map<String, dynamic> data = api.data() as Map<String, dynamic>;
      baseUrl = data['url'] ?? '';
      apiKey = data['key'] ?? '';
    }

    /// Aboutus
    DocumentSnapshot Aboutus = await AIGuruji.doc('Aboutus').get();
    if (Aboutus.exists) {
      Map<String, dynamic> data = Aboutus.data() as Map<String, dynamic>;
      privacy = data['Privacy'] ?? '';
      terms = data['Terms'] ?? '';
      appLink = data['AppLink'] ?? '';
      appRate = data['AppRate'] ?? '';
      version = data['Version'] ?? '';
      buildNumber = data['BuildNumber'] ?? '';
    }
  }
}