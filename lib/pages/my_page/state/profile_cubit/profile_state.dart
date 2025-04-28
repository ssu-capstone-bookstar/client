part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final MemberDto? memberDto;
  final ProfileElseDto? profileElseDto;

  const ProfileState({
    this.memberDto,
    this.profileElseDto,
  });

  ProfileState copyWith({
    MemberDto? memberDto,
    ProfileElseDto? profileElseDto,
  }) {
    return ProfileState(
      memberDto: memberDto ?? this.memberDto,
      profileElseDto: profileElseDto ?? this.profileElseDto,
    );
  }

  @override
  List<Object?> get props => [memberDto, profileElseDto];
}
