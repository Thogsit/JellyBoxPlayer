import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jplayer/resources/j_player_icons.dart';
import 'package:jplayer/src/presentation/widgets/widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    required this.shell,
    super.key,
  });

  final StatefulNavigationShell shell;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late ThemeData _theme;
  late Size _screenSize;
  late bool _isMobile;
  late bool _isDesktop;

  Set<(IconData, String)> get _menuItems => {
        (JPlayer.play_circle_outlined, 'Listen'),
        (JPlayer.search, 'Search'),
        (JPlayer.settings, 'Settings'),
        (JPlayer.download, 'Downloads'),
      };

  void _navigateToItem(int index) => widget.shell.goBranch(
        index,
        initialLocation: index == widget.shell.currentIndex,
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
    _screenSize = MediaQuery.sizeOf(context);

    final deviceType = getDeviceType(_screenSize);
    _isMobile = deviceType == DeviceScreenType.mobile;
    _isDesktop = deviceType == DeviceScreenType.desktop;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.shell.currentIndex;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Visibility(
                  visible: _isDesktop,
                  child: CustomNavigationRail(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 20,
                    ),
                    selectedItemColor: _theme.colorScheme.primary,
                    unselectedItemColor: _theme.colorScheme.onPrimary,
                    selectedFontSize: 16,
                    unselectedFontSize: 16,
                    leading: const Text(
                      'Logo',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(JPlayer.log_out),
                      label: const Text('Log out'),
                    ),
                    selectedIndex: currentIndex,
                    onDestinationSelected: _navigateToItem,
                    destinations: List.generate(
                      _menuItems.length,
                      (index) => NavigationRailDestination(
                        icon: Icon(_menuItems.elementAt(index).$1),
                        label: Text(_menuItems.elementAt(index).$2),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: widget.shell),
              ],
            ),
          ),
          const BottomPlayer(),
        ],
      ),
      bottomNavigationBar: Visibility(
        visible: !_isDesktop,
        child: CupertinoTabBar(
          activeColor: _theme.colorScheme.primary,
          inactiveColor: _theme.colorScheme.onPrimary,
          iconSize: _isMobile ? 28 : 60,
          height: _isMobile ? 56 : 88,
          currentIndex: currentIndex,
          onTap: _navigateToItem,
          items: List.generate(
            _menuItems.length,
            (index) => BottomNavigationBarItem(
              icon: Icon(_menuItems.elementAt(index).$1),
              label: _menuItems.elementAt(index).$2,
            ),
          ),
        ),
      ),
    );
  }
}
