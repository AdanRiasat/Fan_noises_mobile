import 'package:flutter/material.dart';
import 'package:tp_un/pages/home.dart';
import 'package:tp_un/pages/manage_fans.dart';
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
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text(
              "Welcome to super duper fan app",
              style: TextStyle(fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(S.of(context).homeTitle),
            onTap: () {
              Navigator.pop(context);
              widget.onNavigate(const Home());
            },
          ),
          ListTile(
            leading: Icon(Icons.manage_accounts),
            title: Text("Manage Fans"),
            onTap: () {
              Navigator.pop(context);
              widget.onNavigate(ManageFans(setFab: widget.setFab));
            },
          ),
        ],
      ),
    );
  }
}
