import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/bloc/connectivity_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              child: Icon(Icons.ac_unit),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: NoConnection(),
          )
        ],
      ),
    );
  }
}

class NoConnection extends StatelessWidget {
  const NoConnection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        if (state is ConnectivityStatus) {
          if (!state.isConnected) {
            return Container(
              // decoration: BoxDecoration(color: Colors.red),
              child: SafeArea(
                child: Text("Can't Connect to Internet. Retry.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.overline),
              ),
            );
          }
        }
        return Container();
      },
    );
  }
}
