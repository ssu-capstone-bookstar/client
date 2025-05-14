import 'package:flutter/material.dart';
import 'package:bookstar_app/pages/scrap/state/scrap_dto.dart';

/// 스크랩 카드 위젯
class ScrapCardWidget extends StatelessWidget {
  final ScrapDto scrap;
  final VoidCallback? onLikePressed;
  final VoidCallback? onMorePressed;
  final double iconSize;

  const ScrapCardWidget({
    super.key,
    required this.scrap,
    this.onLikePressed,
    this.onMorePressed,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScrapImage(),
          const SizedBox(width: 12),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildScrapImage() {
    return Container(
      height: 240,
      width: 160,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(scrap.scrapImages),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleAndBookImage(),
        const SizedBox(height: 8),
        _buildText(),
        const SizedBox(height: 12),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildTitleAndBookImage() {
    return Row(
      children: [
        Flexible(
          child: Text(
            scrap.bookTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          width: 29,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: NetworkImage(scrap.bookImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildText() {
    return Text(
      scrap.content,
      style: const TextStyle(
        fontSize: 14,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onLikePressed,
          child: Row(
            children: [
              Image.asset(
                'assets/images/good.png',
                width: iconSize,
                height: iconSize,
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
        GestureDetector(
          onTap: onMorePressed,
          child: Row(
            children: [
              Image.asset(
                'assets/images/chat.png',
                width: iconSize,
                height: iconSize,
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
      ],
    );
  }
}
