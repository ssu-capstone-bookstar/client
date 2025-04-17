// import 'dart:convert';

// import 'package:bookstar_app/components/MainScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginPage2 extends StatelessWidget {
//   const LoginPage2({super.key});

//   Future<void> _navigateToMainScreen(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     final accessToken = prefs.getString('accessToken');

//     if (accessToken != null) {
//       try {
//         // API 요청
//         final response = await http.get(
//           Uri.parse('http://15.164.30.67:8080/api/v1/member/me'),
//           headers: {
//             'Authorization': 'Bearer $accessToken',
//           },
//         );

//         if (response.statusCode == 200) {
//           // 응답 데이터를 디코딩
//           final decodedData = jsonDecode(utf8.decode(response.bodyBytes));

//           // 로컬 저장
//           prefs.setInt('id', decodedData['id']);
//           prefs.setString('nickName', decodedData['nickName']);
//           prefs.setString('profileImage', decodedData['profileImage']);

//           // 터미널에 출력
//           print('Stored User Information:');
//           print('ID: ${decodedData['id']}');
//           print('Nickname: ${decodedData['nickName']}');
//           print('Profile Image: ${decodedData['profileImage']}');

//           // 메인 화면으로 이동
//           if (!context.mounted) return;
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//                 builder: (_) => const MainScreen(selectedIndex: 0)),
//           );
//         } else {
//           if (!context.mounted) return;
//           _showErrorDialog(context, 'Failed to fetch user information.');
//         }
//       } catch (e) {
//         if (!context.mounted) return;
//         _showErrorDialog(context, 'An error occurred: $e');
//       }
//     } else {
//       if (!context.mounted) return;
//       _showErrorDialog(context, 'Access token not found. Please log in again.');
//     }
//   }

//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(''),
//         centerTitle: true,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 180),
//           Image.asset(
//             'assets/images/App_LOGO.png',
//             width: 100,
//             height: 100,
//             fit: BoxFit.contain,
//           ),
//           const SizedBox(height: 20),
//           Image.asset(
//             'assets/images/App_Text_LOGO.png',
//             width: 150,
//             height: 50,
//             fit: BoxFit.contain,
//           ),
//           const Spacer(),
//           GestureDetector(
//             onTap: () => _navigateToMainScreen(context),
//             child: Image.asset(
//               'assets/images/Kakao.png',
//               width: 500,
//               height: 60,
//               fit: BoxFit.contain,
//             ),
//           ),
//           const SizedBox(height: 60),
//         ],
//       ),
//     );
//   }
// }
