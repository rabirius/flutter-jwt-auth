import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:news/Exceptions/exceptions.dart';
import 'package:news/bloc/authentication_bloc.dart';
import 'package:news/service/auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginWithUsernamePassword) {
      yield* _mapLoginWithUsernamePasswordToState(event);
    }
  }

  Stream<LoginState> _mapLoginWithUsernamePasswordToState(
      LoginWithUsernamePassword event) async* {
    if (event.username.length == 0 || event.password.length == 0) return;
    try {
      yield LoginInProgress();
      await login(event.username, event.password);
      event.authenticationBloc.add(UserLogIn());
    } on UnauthorizedException {
      yield LoginError(errorMessage: 'Username Or Password Incorrect');
    } on UnknownException {
      yield LoginError(
          errorMessage:
              'Sorry, unable to login. An Unknown error occured during login');
    } on NoInternetException {
      yield LoginError(
          errorMessage:
              'Sorry, unable to login. Please check your internet connection');
    }
  }
}
