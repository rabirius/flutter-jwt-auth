import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:news/Exceptions/exceptions.dart';
import 'package:news/globals/storage.dart';
import 'package:news/globals/tokens.dart';
import 'package:news/service/auth_service.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  @override
  AuthenticationState get initialState => AuthenticationInitial();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppLoaded) {
      yield* _mapApploadedToState(event);
    }
    if (event is UserLogIn) {
      yield* _mapUserLoginToState(event);
    }
    if (event is UserLogOut) {
      yield* _mapUserLogoutToState(event);
    }
  }

  Stream<AuthenticationState> _mapApploadedToState(AppLoaded event) async* {
    // await removeTokens();
    await loadTokenFromLocalStorage();
    if (token.accessToken == null || token.refreshToken == null) {
      yield AuthenticationNotAuhtenticated();
    } else {
      try {
        await refreshToken(token.refreshToken);
        yield AuthenticationAuhtenticated();
      } on InvalidTokenException {
        yield AuthenticationNotAuhtenticated();
      } on NoInternetException {} on UnknownException {}
    }
  }

  Stream<AuthenticationState> _mapUserLoginToState(UserLogIn event) async* {
    yield AuthenticationAuhtenticated();
  }

  Stream<AuthenticationState> _mapUserLogoutToState(UserLogOut event) async* {
    removeTokens();
    yield AuthenticationNotAuhtenticated();
  }
}
