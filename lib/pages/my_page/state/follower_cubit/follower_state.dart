part of 'follower_cubit.dart';

class FollowerState extends Equatable {
  final List<FollowerDto>? followerList;
  final bool? isFollow;

  const FollowerState({
    this.followerList,
    this.isFollow,
  });

  FollowerState copyWith({
    List<FollowerDto>? followerList,
    bool? isFollow,
  }) {
    return FollowerState(
      followerList: followerList ?? followerList,
      isFollow: isFollow ?? this.isFollow,
    );
  }

  @override
  List<Object?> get props => [followerList, isFollow];
}
