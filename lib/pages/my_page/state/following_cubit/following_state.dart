part of 'following_cubit.dart';

class FollowingState extends Equatable {
  final List<FollowingDto>? followingList;
  final bool? isFollow;

  const FollowingState({
    this.followingList,
    this.isFollow,
  });

  FollowingState copyWith({
    List<FollowingDto>? followingList,
    bool? isFollow,
  }) {
    return FollowingState(
      followingList: followingList ?? this.followingList,
      isFollow: isFollow ?? this.isFollow,
    );
  }

  @override
  List<Object?> get props => [followingList, isFollow];
}
