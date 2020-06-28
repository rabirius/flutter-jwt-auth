import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/Widgets/loginPage.dart';
import 'package:news/Widgets/welocmePage.dart';
import 'package:news/bloc/authentication_bloc.dart';
import 'package:news/bloc/connectivity_bloc.dart';
import 'package:news/globals/blocks.dart';
import 'package:news/service/connection_status.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final AuthenticationBloc bloc = AuthenticationBloc();
  final ConnectivityBloc connectivityBloc = ConnectivityBloc();

  StreamSubscription _subscription;
  bool _connected = true;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: bloc),
        BlocProvider.value(value: connectivityBloc),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    bloc.add(AppLoaded());
    WidgetsBinding.instance.addObserver(this);
    _subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        changeConnectivity(result, bloc.state);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _subscription.cancel();
    bloc.close();
    connectivityBloc.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _subscription == null) {
      _subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        changeConnectivity(result, bloc.state);
      });
    }
  }

  void changeConnectivity(
      ConnectivityResult result, AuthenticationState state) {
    if (result != ConnectivityResult.none && state is AuthenticationInitial) {
      bloc.add(AppLoaded());
    }
    if (result == ConnectivityResult.none) {
      connectivityBloc.add(ConnectionStatusChanged(isConnected: false));
    } else {
      connectivityBloc.add(ConnectionStatusChanged(isConnected: true));
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationInitial) {
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
        if (state is AuthenticationNotAuhtenticated) {
          return WelcomePage();
        }
        return MainPage();
      },
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

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            'Hello There',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          BlocProvider.of<AuthenticationBloc>(context).add(UserLogOut());
        },
      ),
    );
  }
}