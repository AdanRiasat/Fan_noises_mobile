import 'package:flutter/material.dart';
import 'package:fan_noises/admob/consent_manager.dart';
import 'package:fan_noises/config/app_links.dart';
import 'package:fan_noises/pages/home.dart';
import 'package:fan_noises/pages/manage_fans.dart';
import 'package:fan_noises/themes/app.theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../generated/l10n.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    super.key,
    required this.onNavigate,
    required this.setFab,
  });

  final void Function(Widget page) onNavigate;
  final void Function(FloatingActionButton?) setFab;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Future<void> _openPrivacyPolicy() async {
    final launched = await launchUrl(
      Uri.parse(AppLinks.privacyPolicy),
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).privacyPolicyUnavailable)),
      );
    }
  }

  Future<void> _openPrivacyOptions() async {
    final messenger = ScaffoldMessenger.of(context);
    final message = S.of(context).privacyOptionsUnavailable;

    final shown = await ConsentManager.showPrivacyOptionsForm();

    if (!shown && mounted) {
      messenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text(
              S.of(context).drawerWelcome,
              style: TextStyle(fontSize: 24, color: AppTheme.primaryText),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              S.of(context).homeTitle,
              style: TextStyle(color: AppTheme.primaryText),
            ),
            onTap: () {
              Navigator.pop(context);
              widget.onNavigate(const Home());
            },
          ),
          ListTile(
            leading: Icon(Icons.manage_accounts),
            title: Text(
              S.of(context).manageFans,
              style: TextStyle(color: AppTheme.primaryText),
            ),
            onTap: () {
              Navigator.pop(context);
              widget.onNavigate(
                ManageFans(
                  setFab: widget.setFab,
                  onNavigate: widget.onNavigate,
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text(
              S.of(context).privacyPolicy,
              style: TextStyle(color: AppTheme.primaryText),
            ),
            onTap: () {
              Navigator.pop(context);
              _openPrivacyPolicy();
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: ConsentManager.privacyOptionsRequired,
            builder: (context, isRequired, _) {
              if (!isRequired) return const SizedBox.shrink();

              return ListTile(
                leading: Icon(Icons.tune),
                title: Text(
                  S.of(context).privacyOptions,
                  style: TextStyle(color: AppTheme.primaryText),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _openPrivacyOptions();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
