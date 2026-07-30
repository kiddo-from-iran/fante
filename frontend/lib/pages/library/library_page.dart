// library_page.dart
import 'package:flutter/material.dart';
import 'package:frontend/pages/library/library_sidebar.dart';
import 'paper_list_view.dart';

enum LibraryView {
  all,
  recentlyAdded,
  collectionBooks,
  collectionMasters,
  myPublications,
  duplicates,
  trash,
  favorites,
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  LibraryView selectedView = LibraryView.all;

  // Sidebar width
  double sidebarWidth = 280;

  // Minimum and maximum width for resizing
  final double minSidebarWidth = 180;
  final double maxSidebarWidth = 500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Resizable Sidebar
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: (details) {
              setState(() {
                sidebarWidth += details.delta.dx;
                if (sidebarWidth < minSidebarWidth) sidebarWidth = minSidebarWidth;
                if (sidebarWidth > maxSidebarWidth) sidebarWidth = maxSidebarWidth;
              });
            },
            child: SizedBox(
              width: sidebarWidth,
              child: LibrarySidebar(
                selectedView: selectedView,
                onSelected: (view) {
                  setState(() => selectedView = view);
                },
              ),
            ),
          ),

          // Divider / drag handle
          MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: Container(
              width: 4,
              color: Colors.transparent,
            ),
          ),

          // Main Paper List
          Expanded(
            child: PaperListView(
              view: selectedView,
            ),
          ),
        ],
      ),
    );
  }
}
