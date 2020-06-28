part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationAuhtenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
}

class AuthenticationNotAuhtenticated extends AuthenticationState {
  @override
  List<Object> get props => [];
}
