import 'package:exercise_journal/src/screens/user_profile.dart';
import 'package:exercise_journal/src/screens/workout_view.dart';
import 'package:exercise_journal/src/styles/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class NavBar {
  static CupertinoTabScaffold get cupertinoTabScaffold {
    return CupertinoTabScaffold(
      tabBar: _cupertinoTabBar,
      tabBuilder: (context, index) {
        return _pageSelection(index);
      },
    );
  }

  static CupertinoTabBar get _cupertinoTabBar {
    return CupertinoTabBar(
      activeColor: AppColours.primaryButton,
      inactiveColor: AppColours.disabled,
//      backgroundColor: AppColours.secondary,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.add_circled),
          label: 'Workout',
        ),
//        BottomNavigationBarItem(
//          icon: Icon(CupertinoIcons.collections),
//          title: Text('History'),
//        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.profile_circled),
          label: 'Profile',
        ),
      ],
    );
  }

  static Widget _pageSelection(int index) {
    if (index == 0) {
      return const WorkoutView();
    }
//    if (index == 1) {
//      return History();
//    }
    return const UserProfile();
  }

  static const tabBarLength = 2;

  static TabBar get materialTabBar {
    return TabBar(
      unselectedLabelColor: AppColours.disabled,
      labelColor: AppColours.primaryButton,
      indicatorColor: AppColours.primaryButton,
      tabs: const <Widget>[
        Tab(
          icon: Icon(Icons.add_box),
          text: 'Workout',
        ),
//        Tab(
//          icon: Icon(Icons.storage),
//          text: 'History',
//        ),
        Tab(
          icon: Icon(Icons.person),
          text: 'Profile',
        ),
      ],
    );
  }

  static TabBarView get materialTabBarView {
    return const TabBarView(
      children: <Widget>[
        WorkoutView(),
//        History(),
        UserProfile(),
      ],
    );
  }
}
