import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/Widgets/ProfilePage.dart';
import 'package:news/bloc/authentication_bloc.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ScrollController _scrollController;
  List<String> _tabs = ['One', 'Two'];
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                floating: true,
                // forceElevated: innerBoxIsScrolled,
                snap: true,
                title: Text(
                  'News',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
                bottom: TabBar(
                  indicatorColor: Theme.of(context).indicatorColor,
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(
                        Icons.satellite,
                        color: Colors.black,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: _tabs.map((String name) {
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      key: PageStorageKey<String>(name),
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: ProfilePage(),
                        ),
                      ],
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            BlocProvider.of<AuthenticationBloc>(context).add(UserLogOut());
          },
        ),
      ),
    );
  }
}

class BuildCustomTabBarView extends StatelessWidget {
  final Widget child;
  const BuildCustomTabBarView({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: child,
          )
        ],
      ),
    );
  }
}
