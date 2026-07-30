import 'package:flutter/material.dart';

/// ========================================
/// Collaboration Page — Modern Research Hub
/// ========================================
class CollaborationPage extends StatefulWidget {
  const CollaborationPage({super.key});

  @override
  State<CollaborationPage> createState() => _CollaborationPageState();
}

class _CollaborationPageState extends State<CollaborationPage> {
  int selectedOrgIndex = 0;
  int selectedProjectIndex = 0;

  // ✅ Only use _OrgData
  final List<_OrgData> organizations = const [
    _OrgData(name: "Solo Researcher", projects: ["My Paper"]),
    _OrgData(
      name: "AI Research Lab",
      projects: ["Literature Review", "Data Analysis Paper"],
    ),
    _OrgData(
      name: "Community Research Group",
      projects: ["Global Research Initiative", "Open Data Study"],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedOrg = organizations[selectedOrgIndex];

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page header
          const Text(
            "Collaboration Dashboard",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "Work together on documents, chat, comment, and track your team's progress",
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),

          // Organization selector
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: organizations.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                if (index == organizations.length) {
                  return OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text("New Org"),
                  );
                }
                final isSelected = index == selectedOrgIndex;
                return ChoiceChip(
                  label: Text(organizations[index].name),
                  selected: isSelected,
                  onSelected: (_) => setState(() => selectedOrgIndex = index),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: Row(
              children: [
                // Left panel: Projects
                SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text("Projects",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      ...selectedOrg.projects
                          .asMap()
                          .entries
                          .map((entry) => ListTile(
                                title: Text(entry.value),
                                selected: selectedProjectIndex == entry.key,
                                onTap: () =>
                                    setState(() => selectedProjectIndex = entry.key),
                              ))
                          .toList(),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text("New Project"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Workspace + Comments + Chat
                Expanded(
                  child: Column(
                    children: [
                      // Workspace placeholder
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Workspace / Live Editor Here",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Expanded(
                        child: Row(
                          children: [
                            // Comments panel
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: const [
                                    Text("Comments",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(height: 8),
                                    _CommentItem(
                                        author: "Alice",
                                        content: "Consider updating section 2."),
                                    _CommentItem(
                                        author: "Bob",
                                        content: "Add more references!"),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Chat panel
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: const [
                                    Text("Chat",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(height: 8),
                                    _ChatItem(
                                        user: "Me",
                                        message: "I just updated the intro!"),
                                    _ChatItem(
                                        user: "Eve",
                                        message: "Looks good!"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------
/// Data Classes & Widgets
/// ------------------------

// Only one organization data class used
class _OrgData {
  final String name;
  final List<String> projects;
  const _OrgData({required this.name, required this.projects});
}

// Comment item
class _CommentItem extends StatelessWidget {
  final String author;
  final String content;

  const _CommentItem({required this.author, required this.content});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.comment),
      title: Text(author),
      subtitle: Text(content),
    );
  }
}

// Chat item
class _ChatItem extends StatelessWidget {
  final String user;
  final String message;

  const _ChatItem({required this.user, required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.chat_bubble),
      title: Text(user),
      subtitle: Text(message),
    );
  }
}
