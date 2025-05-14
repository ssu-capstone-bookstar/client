import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstar_app/components/scrap_card_widget.dart';
import 'package:bookstar_app/pages/scrap/state/scrap_cubit/scrap_cubit.dart';

/// 스크랩 카드 화면
class ScrapCardScreen extends StatelessWidget {
  final int scrapId;
  final int memberId;
  final VoidCallback? onLikePressed;
  final VoidCallback? onMorePressed;
  final double iconSize;

  const ScrapCardScreen({
    super.key,
    required this.scrapId,
    required this.memberId,
    this.onLikePressed,
    this.onMorePressed,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScrapCubit()
        ..fetchScrapDetail(
          memberId: memberId,
          scrapId: scrapId,
        ),
      child: BlocBuilder<ScrapCubit, ScrapState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }

          if (state.scrap == null) {
            return const Center(child: Text('No data available'));
          }

          return ScrapCardWidget(
            scrap: state.scrap!,
            onLikePressed: onLikePressed,
            onMorePressed: onMorePressed,
            iconSize: iconSize,
          );
        },
      ),
    );
  }
}
