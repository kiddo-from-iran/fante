import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  bool notifyComments = true;
  bool notifyMentions = true;
  bool autoSave = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Settings",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "Customize your Avesta workspace, appearance, and notifications",
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),

          _SettingsSection(
            title: "Appearance",
            children: [
              SwitchListTile(
                title: const Text("Dark Mode"),
                value: darkMode,
                onChanged: (val) => setState(() => darkMode = val),
                secondary: const Icon(Icons.dark_mode),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _SettingsSection(
            title: "Notifications",
            children: [
              SwitchListTile(
                title: const Text("Comments & Mentions"),
                value: notifyComments,
                onChanged: (val) => setState(() => notifyComments = val),
                secondary: const Icon(Icons.comment),
              ),
              SwitchListTile(
                title: const Text("Mentions only"),
                value: notifyMentions,
                onChanged: (val) => setState(() => notifyMentions = val),
                secondary: const Icon(Icons.alternate_email),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _SettingsSection(
            title: "Workspace",
            children: [
              SwitchListTile(
                title: const Text("Auto-save documents"),
                value: autoSave,
                onChanged: (val) => setState(() => autoSave = val),
                secondary: const Icon(Icons.save),
              ),
              ListTile(
                leading: const Icon(Icons.folder_open),
                title: const Text("Default save location"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 16),

          _SettingsSection(
            title: "Account & About",
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text("About Avesta"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Sign out"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 32), // extra bottom padding
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}
