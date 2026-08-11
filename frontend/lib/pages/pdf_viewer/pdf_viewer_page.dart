import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:frontend/widgets/toast/app_toast.dart';

class PdfViewerPage extends StatefulWidget {
  final String assetPath;

  const PdfViewerPage({
    super.key,
    required this.assetPath,
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  PdfController? _regularController;
  PdfControllerPinch? _pinchController;

  int _currentPage = 1;
  int _totalPages = 0;
  bool _nightMode = false;
  bool _searchBarVisible = false;

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Use pinch zoom only on platforms where it's reliably supported
    final usePinch = !Platform.isWindows && !Platform.isLinux;

    if (usePinch) {
      _pinchController = PdfControllerPinch(
        document: PdfDocument.openAsset(widget.assetPath),
      );
    } else {
      _regularController = PdfController(
        document: PdfDocument.openAsset(widget.assetPath),
      );
    }

    _loadDocument();
  }

  Future<void> _loadDocument() async {
    try {
      final doc = await PdfDocument.openAsset(widget.assetPath);
      if (!mounted) return;

      setState(() {
        _totalPages = doc.pagesCount;
        _currentPage = 1;
      });
    } catch (e) {
      if (!mounted) return;
      AppToast.error(context, 'Failed to open PDF: $e');
    }
  }

  @override
  void dispose() {
    _regularController?.dispose();
    _pinchController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    if (page < 1 || page > _totalPages) return;

    if (_pinchController != null) {
      _pinchController!.jumpToPage(page);
    } else if (_regularController != null) {
      _regularController!.jumpToPage(page);
    }
  }

  Future<void> _shareDocument() async {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final rect = box.localToGlobal(Offset.zero) & box.size;

    try {
      await Share.shareXFiles(
        [XFile(widget.assetPath)],
        sharePositionOrigin: rect,
      );
    } catch (e) {
      if (!mounted) return;
      AppToast.error(context, 'Share failed: $e');
    }
  }

  Future<void> _printDocument() async {
    try {
      final bytes = await File(widget.assetPath).readAsBytes();
      await Printing.layoutPdf(
        onLayout: (_) => bytes,
        name: widget.assetPath.split('/').last,
      );
    } catch (e) {
      if (!mounted) return;
      AppToast.error(context, 'Print failed: $e');
    }
  }

  Widget _buildPdfViewer() {
    final isDark = Theme.of(context).brightness == Brightness.dark || _nightMode;
    final background = isDark ? Colors.grey[850] : Colors.white;

    if (_pinchController != null) {
      return PdfViewPinch(
        controller: _pinchController!,
        scrollDirection: Axis.vertical,
        padding: 8,
        minScale: 0.8,
        maxScale: 5.0,
        backgroundDecoration: BoxDecoration(color: background),
        onPageChanged: (page) {
          if (mounted) {
            setState(() => _currentPage = page);
          }
        },
      );
    }

    if (_regularController != null) {
      return PdfView(
        controller: _regularController!,
        scrollDirection: Axis.vertical,
        backgroundDecoration: BoxDecoration(color: background),
        onPageChanged: (page) {
          if (mounted) {
            setState(() => _currentPage = page);
          }
        },
      );
    }

    // Loading / fallback state
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark || _nightMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        title: Text(
          widget.assetPath.split('/').last,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (_searchBarVisible)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search not supported in pdfx',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchBarVisible = false);
                      },
                    ),
                  ),
                  onSubmitted: (_) => setState(() => _searchBarVisible = false),
                ),
              ),
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search (not implemented)',
              onPressed: () => setState(() => _searchBarVisible = true),
            ),
            IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Share',
              onPressed: _shareDocument,
            ),
            IconButton(
              icon: const Icon(Icons.print),
              tooltip: 'Print',
              onPressed: _printDocument,
            ),
            IconButton(
              icon: Icon(_nightMode ? Icons.light_mode : Icons.dark_mode),
              tooltip: _nightMode ? 'Light mode' : 'Night mode',
              onPressed: () => setState(() => _nightMode = !_nightMode),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildPdfViewer()),

          // Bottom navigation bar
          Material(
            elevation: 8,
            child: Container(
              color: theme.colorScheme.surface,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
                    ),
                    GestureDetector(
                      onTap: () {
                        final ctrl = TextEditingController(text: '$_currentPage');
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Go to page'),
                            content: TextField(
                              controller: ctrl,
                              keyboardType: TextInputType.number,
                              autofocus: true,
                              decoration: const InputDecoration(hintText: 'Page number'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  final num = int.tryParse(ctrl.text.trim());
                                  if (num != null && num >= 1 && num <= _totalPages) {
                                    _goToPage(num);
                                  }
                                  Navigator.pop(ctx);
                                },
                                child: const Text('Go'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$_currentPage / $_totalPages',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _currentPage < _totalPages ? () => _goToPage(_currentPage + 1) : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}