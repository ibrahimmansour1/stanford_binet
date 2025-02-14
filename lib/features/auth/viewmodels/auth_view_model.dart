import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/specialist_model.dart';
import '../repositories/auth_repository.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  FutureOr<SpecialistModel?> build() {
    return ref.watch(authRepositoryProvider.future);
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() =>
        ref.read(authRepositoryProvider.notifier).signInWithEmailAndPassword(
              email,
              password,
            ));
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider.notifier).signOut();
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider.notifier).resetPassword(email);
      return state.value;
    });
  }

  bool get isAuthenticated => state.value != null;
  bool get isGuest => state.value?.email == null;
}
