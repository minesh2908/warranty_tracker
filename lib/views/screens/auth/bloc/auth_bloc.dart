import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:track_my_things/modal/user_model.dart';
import 'package:track_my_things/repository/auth_repository.dart';
import 'package:track_my_things/repository/product_repository.dart';
import 'package:track_my_things/repository/user_repository.dart';
import 'package:track_my_things/service/shared_prefrence.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {});
    on<GoogleSignInEvent>(googleSignInEvent);
    on<GoogleSignOutEvent>(googleSignOutEvent);
    on<UpdateUserAccountDetails>(updateUserAccountDetails);
    on<DeleteAccount>(deleteAccount);
    on<GetCurrentUserData>(getCurrentUserData);
  }

  FutureOr<void> googleSignInEvent(
    GoogleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final user = await AuthRepository().signInWithGoogle();
      if (user != null) {
        emit(AuthSuccessState());
      }
    } catch (e) {
      emit(AuthFailureState(e.toString()));
    }
  }

  FutureOr<void> googleSignOutEvent(
    GoogleSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final isSignOut = await AuthRepository().signOutFromGoogle();
      if (isSignOut) {
        emit(AuthSuccessState());
      }
    } catch (e) {
      emit(AuthFailureState(e.toString()));
    }
  }

  FutureOr<void> updateUserAccountDetails(
    UpdateUserAccountDetails event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    try {
      await UserRepository().updateUser(event.userModel);
      emit(AccountUpdatedState());
      emit(UserDateFetchedSuccessfullyState());
    } catch (e) {
      throw Exception(e);
    }
  }

  FutureOr<void> deleteAccount(
    DeleteAccount event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final productList = await ProductRepository().getAllProducts();

      await ProductRepository().deleteAllProduct(productList);
      await UserRepository().deleteUser(AppPrefHelper.getUID());

      emit(AccountDeletedState());
    } catch (e) {
      emit(AuthFailureState(e.toString()));
    }
  }

  FutureOr<void> getCurrentUserData(
    GetCurrentUserData event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoadingState());
      final currentUser = FirebaseAuth.instance.currentUser?.uid;
      final userData =
          await UserRepository().getCurrentUserDetails(currentUser!);

      emit(UserDateFetchedSuccessfullyState(userModel: userData));
    } catch (e) {
      emit(AuthFailureState(e.toString()));
      throw Exception(e);
    }
  }
}
