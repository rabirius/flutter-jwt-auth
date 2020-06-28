part of 'connectivity_bloc.dart';

abstract class ConnectivityState extends Equatable {
  const ConnectivityState();
}

class ConnectivityInitial extends ConnectivityState {
  @override
  List<Object> get props => [];
}

class ConnectivityStatus extends ConnectivityState {
  final bool isConnected;
  ConnectivityStatus({@required this.isConnected});
  @override
  List<Object> get props => [isConnected];
}
