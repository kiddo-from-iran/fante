import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'editor_toolbar.dart';
import 'editor_area.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late QuillController _controller;
  bool isRTL = false;

  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Studio Editor",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // 🔹 Toolbar
          EditorToolbar(
            controller: _controller,
            isRTL: isRTL,
            onToggleDirection: () {
              setState(() => isRTL = !isRTL);
            },
          ),

          const SizedBox(height: 16),

          // 🔹 Editor Area
          Expanded(
            child: EditorArea(
              controller: _controller,
              isRTL: isRTL,
            ),
          ),
        ],
      ),
    );
  }
}
