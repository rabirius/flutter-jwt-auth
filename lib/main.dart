import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/Widgets/mainPage.dart';
import 'package:news/Widgets/splashScreen.dart';
import 'package:news/Widgets/welocmePage.dart';
import 'package:news/bloc/authentication_bloc.dart';
import 'package:news/bloc/connectivity_bloc.dart';

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
          return SplashScreen();
        }
        if (state is AuthenticationNotAuhtenticated) {
          return WelcomePage();
        }
        return MainPage();
      },
    );
  }
}
