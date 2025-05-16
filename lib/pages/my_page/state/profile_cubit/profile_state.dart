part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  final ProfileDto? memberDto;
  final ProfileElseDto? profileElseDto;
  final bool? isWrite;

  const ProfileState({
    this.memberDto,
    this.profileElseDto,
    this.isWrite = false,
  });

  ProfileState copyWith({
    ProfileDto? memberDto,
    ProfileElseDto? profileElseDto,
    bool? isWrite,
  }) {
    return ProfileState(
      memberDto: memberDto ?? this.memberDto,
      profileElseDto: profileElseDto ?? this.profileElseDto,
      isWrite: isWrite ?? this.isWrite,
    );
  }

  @override
  List<Object?> get props => [
        memberDto,
        profileElseDto,
        isWrite,
      ];
}
