// paper_list_view.dart
import 'package:flutter/material.dart';
import 'package:frontend/models/paper.dart';
import 'library_page.dart';
import 'package:frontend/pages/pdf_viewer/pdf_viewer_page.dart'; // ensure correct path

class PaperListView extends StatefulWidget {
  final LibraryView view;

  const PaperListView({super.key, required this.view});

  @override
  State<PaperListView> createState() => _PaperListViewState();
}

class _PaperListViewState extends State<PaperListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final papers = _getPapersForView(widget.view);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
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
            _tableHeader(),
            const Divider(height: 1),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                thickness: 8,
                radius: const Radius.circular(4),
                trackVisibility: true,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: papers.length,
                  itemBuilder: (context, index) {
                    return _paperRow(context, papers[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Paper> _getPapersForView(LibraryView view) {
  switch (view) {
    case LibraryView.collectionBooks:
      return allPapers.where((p) => p.collection == 'Books').toList();
    case LibraryView.collectionMasters:
      return allPapers.where((p) => p.collection == 'Masters').toList();
    case LibraryView.all:
    default:
      return allPapers;
  }
}

Widget _tableHeader() {
  return Container(
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    color: Colors.grey[50],
    child: Row(
      children: const [
        SizedBox(width: 40),
        Expanded(flex: 3, child: Text('AUTHORS', style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text('YEAR', style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(flex: 4, child: Text('TITLE', style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(flex: 3, child: Text('SOURCE', style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text('ADDED', style: TextStyle(fontWeight: FontWeight.bold))),
        SizedBox(width: 40),
      ],
    ),
  );
}

Widget _paperRow(BuildContext context, Paper paper) {
  return Container(
    height: 64,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
    ),
    child: Row(
      children: [
        Checkbox(value: false, onChanged: (_) {}),
        const SizedBox(width: 8),
        const Icon(Icons.circle, size: 10, color: Colors.green),
        const SizedBox(width: 8),
        Expanded(flex: 3, child: Text(paper.authors, overflow: TextOverflow.ellipsis)),
        Expanded(child: Text(paper.year.toString())),
        Expanded(flex: 4, child: Text(paper.title, overflow: TextOverflow.ellipsis)),
        Expanded(flex: 3, child: Text(paper.source, overflow: TextOverflow.ellipsis)),
        Expanded(child: Text(paper.added)),
        IconButton(
          icon: const Icon(Icons.picture_as_pdf),
          tooltip: 'Open PDF',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PdfViewerPage(assetPath: 'assets/sample.pdf'),
              ),
            );
          },
        ),
      ],
    ),
  );
}
