part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final MemberDto? memberDto;

  const ProfileState({
    this.memberDto,
  });

  ProfileState copyWith({
    MemberDto? memberDto,
  }) {
    return ProfileState(
      memberDto: memberDto ?? this.memberDto,
    );
  }

  @override
  List<Object?> get props => [memberDto];
}
