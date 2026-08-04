import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fan_noises/admob/consent_manager.dart';
import 'package:fan_noises/admob/footer_ad_banner.dart';
import 'package:fan_noises/pages/home.dart';
import 'package:fan_noises/widgets/drawer.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  Widget _currentPage = const Home();
  FloatingActionButton? _fab;

  bool get _isHome => _currentPage is Home;

  @override
  void initState() {
    super.initState();

    unawaited(
      ConsentManager.gatherConsentAndInitializeAds().catchError((
        Object error,
        StackTrace stack,
      ) {
        if (kDebugMode) debugPrint('Consent init failed: $error');
      }),
    );
  }

  void _navigateTo(Widget page) {
    if (_currentPage.runtimeType == page.runtimeType) return;

    setState(() {
      _currentPage = page;
    });
  }

  void _setFab(FloatingActionButton? fab) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() {
        _fab = fab;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _isHome,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        setState(() {
          _currentPage = const Home();
        });
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
        drawer: CustomDrawer(onNavigate: _navigateTo, setFab: _setFab),
        body: _currentPage,
        floatingActionButton: _fab,
        bottomNavigationBar: FooterAdBanner(),
      ),
    );
  }
}

abstract class HasFab {
  FloatingActionButton buildFab(BuildContext context);
}
