import 'package:flutter/material.dart';
import 'library_page.dart';

class LibrarySidebar extends StatefulWidget {
  final LibraryView selectedView;
  final ValueChanged<LibraryView> onSelected;

  const LibrarySidebar({
    super.key,
    required this.selectedView,
    required this.onSelected,
  });

  @override
  State<LibrarySidebar> createState() => _LibrarySidebarState();
}

class _LibrarySidebarState extends State<LibrarySidebar>
    with TickerProviderStateMixin {
  bool showSearch = false;
  final TextEditingController searchController = TextEditingController();

  // Track expanded state for collections
  final Map<String, bool> expandedCollections = {
    'Books': false,
    'Masters': false,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // distance from surrounding content
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            _topActionBar(),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _iconItem(
                    'All References',
                    LibraryView.all,
                    Icons.folder_open,
                  ),
                  _iconItem(
                    'Recently Added',
                    LibraryView.recentlyAdded,
                    Icons.fiber_new,
                  ),
                  _iconItem('Favorites', LibraryView.favorites, Icons.star),
                  _iconItem(
                      'My Publications', LibraryView.myPublications, Icons.article),
                  _iconItem('Duplicate Items', LibraryView.duplicates, Icons.copy),
                  _iconItem('Trash', LibraryView.trash, Icons.delete),
                  const SizedBox(height: 24),
                  _section('COLLECTIONS'),
                  _expandableCollection('Books', LibraryView.collectionBooks, [
                    'Book 1',
                    'Book 2',
                  ]),
                  _expandableCollection('Masters', LibraryView.collectionMasters, [
                    'Master 1',
                    'Master 2',
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topActionBar() {
    if (showSearch) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          controller: searchController,
          autofocus: true,
          onChanged: (value) {},
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search library…',
            isDense: true,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  showSearch = false;
                  searchController.clear();
                });
              },
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _iconButton(
            icon: Icons.create_new_folder_outlined,
            tooltip: 'Add new collection',
            onTap: () {},
          ),
          _iconButton(
            icon: Icons.group_add_outlined,
            tooltip: 'Add new group',
            onTap: () {},
          ),
          _iconButton(
            icon: Icons.note_add_outlined,
            tooltip: 'Add new reference',
            onTap: () {},
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              setState(() => showSearch = true);
            },
          ),
        ],
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return IconButton(
      icon: Icon(icon, size: 20),
      tooltip: tooltip,
      onPressed: onTap,
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _iconItem(String title, LibraryView view, IconData icon) {
    final selected = widget.selectedView == view;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          size: 20,
          color: selected ? Colors.blue : Colors.black87,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: selected ? Colors.blue : Colors.black87,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: selected,
        hoverColor: Colors.grey.withOpacity(0.1),
        onTap: () => widget.onSelected(view),
      ),
    );
  }

  Widget _expandableCollection(
      String title, LibraryView view, List<String> subItems) {
    final isExpanded = expandedCollections[title] ?? false;
    final selected = widget.selectedView == view;

    return Column(
      children: [
        GestureDetector(
          onSecondaryTapDown: (details) =>
              _showContextMenu(details.globalPosition, title),
          child: ListTile(
            dense: true,
            title: Text(title, style: const TextStyle(fontSize: 14)),
            selected: selected,
            selectedTileColor: const Color(0xFFE8F0FE),
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: const Icon(Icons.expand_more, size: 20),
            ),
            onTap: () {
              setState(() {
                expandedCollections[title] = !isExpanded;
              });
            },
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: ConstrainedBox(
            constraints: isExpanded
                ? const BoxConstraints()
                : const BoxConstraints(maxHeight: 0),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: subItems
                    .map(
                      (sub) => _subCollectionItem(sub, view),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _subCollectionItem(String title, LibraryView parentView) {
    final selected = widget.selectedView == parentView;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          dense: true,
          title: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: selected ? Colors.blue : Colors.black87,
            ),
          ),
          hoverColor: Colors.grey.withOpacity(0.1),
          onTap: () => widget.onSelected(parentView),
        ),
      ),
    );
  }

  void _showContextMenu(Offset position, String collectionName) async {
    final selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      items: [
        const PopupMenuItem(value: 'add', child: Text('Add Sub-collection')),
        const PopupMenuItem(value: 'remove', child: Text('Remove Collection')),
      ],
    );

    if (selected == 'add') {
      debugPrint('Add sub-collection to $collectionName');
    } else if (selected == 'remove') {
      setState(() {
        expandedCollections.remove(collectionName);
      });
      debugPrint('Removed collection $collectionName');
    }
  }
}
