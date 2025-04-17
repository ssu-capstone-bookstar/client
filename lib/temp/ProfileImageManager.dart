// import 'dart:io';

// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';

// class ProfileImageManager {
//   // 이미지를 로컬에 저장
//   Future<void> saveProfileImage(String url) async {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final directory = await getApplicationDocumentsDirectory();
//       final filePath = '${directory.path}/profile_image.png';
//       File file = File(filePath);
//       await file.writeAsBytes(response.bodyBytes);
//     }
//   }

//   // 로컬에 저장된 이미지를 로드
//   Future<File?> loadProfileImage() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final filePath = '${directory.path}/profile_image.png';
//     File file = File(filePath);
//     if (await file.exists()) {
//       return file;
//     }
//     return null;
//   }
// }
