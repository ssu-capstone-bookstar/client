import 'package:bookstar_app/components/ReviewCard.dart';
import 'package:bookstar_app/components/ScrapCard.dart';
import 'package:flutter/material.dart';

class PopCard {
  static void show({
    required BuildContext context,
    required String feedType,
    required int? reviewId,
    required int? scrapId,
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
                              color: Colors.white.withOpacity(0.1),
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
                              onLikePressed: () {
                                // Handle like action
                              },
                              onMorePressed: () {
                                // Handle more action
                              },
                              iconSize: 24,
                            ),
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
}
