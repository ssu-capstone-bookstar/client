part of 'follower_cubit.dart';

class FollowerState extends Equatable {
  final List<FollowerDto>? followerList;

  const FollowerState({
    this.followerList,
  });

  FollowerState copyWith({
    List<FollowerDto>? followerList,
  }) {
    return FollowerState(
      followerList: followerList ?? followerList,
    );
  }

  @override
  List<Object?> get props => [followerList];
}
