import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditorToolbar extends StatelessWidget {
  final QuillController controller;
  final bool isRTL;
  final VoidCallback onToggleDirection;

  const EditorToolbar({
    super.key,
    required this.controller,
    required this.isRTL,
    required this.onToggleDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // 🔤 Font Family
          QuillToolbarFontFamilyButton(controller: controller),

          // 🔠 Font Size
          QuillToolbarFontSizeButton(controller: controller),

          const VerticalDivider(),

          // ✏️ Bold / Italic / Underline / Strike
          QuillToolbarToggleStyleButton(
            controller: controller,
            attribute: Attribute.bold,
          ),
          QuillToolbarToggleStyleButton(
            controller: controller,
            attribute: Attribute.italic,
          ),
          QuillToolbarToggleStyleButton(
            controller: controller,
            attribute: Attribute.underline,
          ),
          QuillToolbarToggleStyleButton(
            controller: controller,
            attribute: Attribute.strikeThrough,
          ),

          const VerticalDivider(),

          // 🎨 Text Color
          QuillToolbarColorButton(
            controller: controller,
            isBackground: false, // TEXT COLOR
          ),

          // 🟨 Highlight Color
          QuillToolbarColorButton(
            controller: controller,
            isBackground: true, // BACKGROUND COLOR
          ),

          const VerticalDivider(),

          // 📐 Alignment
          QuillToolbarToggleStyleButton(
            controller: controller,
            attribute: Attribute.leftAlignment,
          ),
          QuillToolbarToggleStyleButton(
            controller: controller,
            attribute: Attribute.centerAlignment,
          ),
          QuillToolbarToggleStyleButton(
            controller: controller,
            attribute: Attribute.rightAlignment,
          ),
          QuillToolbarToggleStyleButton(
            controller: controller,
            attribute: Attribute.justifyAlignment,
          ),

          const VerticalDivider(),

          // 🔢 Lists
          QuillToolbarToggleStyleButton(
            controller: controller,
            attribute: Attribute.ul,
          ),
          QuillToolbarToggleStyleButton(
            controller: controller,
            attribute: Attribute.ol,
          ),

          const VerticalDivider(),

          // 🔁 LTR / RTL
          IconButton(
            tooltip: "Toggle LTR / RTL",
            onPressed: onToggleDirection,
            icon: Icon(
              isRTL
                  ? Icons.format_textdirection_r_to_l
                  : Icons.format_textdirection_l_to_r,
            ),
          ),
        ],
      ),
    );
  }
}
