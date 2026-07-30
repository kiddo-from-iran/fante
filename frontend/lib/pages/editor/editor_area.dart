import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditorArea extends StatefulWidget {
  final QuillController controller;
  final bool isRTL;

  const EditorArea({
    super.key,
    required this.controller,
    required this.isRTL,
  });

  @override
  State<EditorArea> createState() => _EditorAreaState();
}

class _EditorAreaState extends State<EditorArea> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Directionality(
        textDirection:
            widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
        child: QuillEditor(
          controller: widget.controller,
          scrollController: _scrollController,
          focusNode: _focusNode,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
