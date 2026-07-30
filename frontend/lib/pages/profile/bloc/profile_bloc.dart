import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/profile_repository.dart';
import 'package:frontend/pages/profile/bloc/profile_event.dart';
import 'package:frontend/pages/profile/bloc/profile_state.dart';

export 'profile_event.dart';
export 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._profileRepository) : super(const ProfileInitial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
  }

  final ProfileRepository _profileRepository;

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final profile = await _profileRepository.getMyProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      final message = e.toString();
      if (message.contains('403') || message.contains('members')) {
        emit(const ProfileFailure(
          'پروفایل بازیکن فقط برای اعضای عادی در دسترس است',
        ));
      } else if (message.contains('401')) {
        emit(const ProfileFailure('لطفاً ابتدا وارد حساب کاربری شوید'));
      } else {
        emit(const ProfileFailure('بارگذاری پروفایل با خطا مواجه شد'));
      }
    }
  }
}
