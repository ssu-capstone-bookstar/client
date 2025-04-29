part of 'following_cubit.dart';

class FollowingState extends Equatable {
  final List<FollowingDto>? followingList;

  const FollowingState({
    this.followingList,
  });

  FollowingState copyWith({
    List<FollowingDto>? followingList,
  }) {
    return FollowingState(
      followingList: followingList ?? this.followingList,
    );
  }

  @override
  List<Object?> get props => [
        followingList,
      ];
}
