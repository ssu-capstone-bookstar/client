import 'package:bookstar_app/components/ReviewCard.dart';
import 'package:bookstar_app/components/ScrapCard.dart';
import 'package:flutter/material.dart';

class PopCard {
  static void show({
    required BuildContext context,
    required String feedType,
    required int? reviewId,
    required int? scrapId,
    required int? memberId,
  }) {
    showDialog(
      context: context,
      barrierColor:
          Colors.black.withOpacity(0.5), // Semi-transparent background
      builder: (BuildContext context) {
        // Get screen size
        final screenHeight = MediaQuery.of(context).size.height;

        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 24),
          child: Stack(
            children: [
              // Positioning container - places content at 1/4 of screen height
              Positioned(
                top: screenHeight * 0.25, // 25% from the top
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Close button at the top right
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, right: 2.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(190, 255, 255, 255),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.black87,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Content - either ReviewCard or ScrapCard with white background extending 10 pixels
                    Stack(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                          child: feedType.toLowerCase() == 'review'
                              ? ReviewCard(
                                  reviewId: reviewId ?? 0,
                                  memberId: memberId ?? 0,
                                  onLikePressed: () {
                                    // Handle like action
                                  },
                                  onMorePressed: () {
                                    // Handle more action
                                  },
                                  iconSize: 24,
                                )
                              : Scrapcard(
                                  scrapId: scrapId ?? 0,
                                  memberId: memberId ?? 0,
                                  onLikePressed: () {
                                    // Handle like action
                                  },
                                  onMorePressed: () {
                                    // Handle more action
                                  },
                                  iconSize: 24,
                                ),
                        ),

                        // 신고 버튼 (오른쪽 아래에 배치)
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: GestureDetector(
                            onTap: () {
                              // 신고 팝업 표시
                              _showReportDialog(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '🚨신고',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 신고 확인 다이얼로그 표시
  static void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            '이 게시물을 신고하시겠습니까?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            // 게시물 신고하기 버튼 (빨간색)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 현재 다이얼로그 닫기
                _showReportConfirmation(context); // 신고 완료 메시지 표시
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // 글자 색 빨간색
                backgroundColor: Colors.white, // 배경색 흰색으로 변경 (필요시 제거 가능)
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.red, width: 2), // 테두리 빨간색 추가
                ),
              ),
              child: Text(
                '게시물 신고하기',
                style: TextStyle(
                  color: Colors.red, // 글자 색 빨간색 (명확한 적용을 위해 추가)
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 취소 버튼 (하늘색)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 현재 다이얼로그 닫기
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(113, 0, 0, 0), // 글자 색 빨간색
                backgroundColor: Colors.white, // 배경색 흰색으로 변경 (필요시 제거 가능)
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                      color: const Color.fromARGB(134, 0, 0, 0),
                      width: 2), // 테두리 빨간색 추가
                ),
              ),
              child: Text(
                '취소',
                style: TextStyle(
                  color: const Color.fromARGB(
                      196, 0, 0, 0), // 글자 색 빨간색 (명확한 적용을 위해 추가)
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 신고 완료 알림 표시
  static void _showReportConfirmation(BuildContext context) {
    // 잠시 동안 메시지 표시 후 자동으로 닫기
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // 1.5초 후 자동으로 닫히도록 설정
        Future.delayed(Duration(milliseconds: 1500), () {
          Navigator.of(context).pop(); // 팝업 닫기
          Navigator.of(context).pop(); // 기존 팝업도 닫기
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            '신고가 접수되었습니다',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
