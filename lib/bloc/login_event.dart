part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginWithUsernamePassword extends LoginEvent {
  final AuthenticationBloc authenticationBloc;
  final String username, password;
  LoginWithUsernamePassword(
      {@required this.authenticationBloc,
      @required this.username,
      this.password});
  @override
  List<Object> get props => [username, password];
}
