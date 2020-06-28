part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();
}

class ConnectionStatusChanged extends ConnectivityEvent {
  final bool isConnected;
  ConnectionStatusChanged({@required this.isConnected});

  @override
  List<Object> get props => [isConnected];
}
