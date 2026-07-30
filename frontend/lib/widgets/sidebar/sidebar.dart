import 'package:flutter/material.dart';
import 'package:frontend/widgets/sidebar/profile.dart';

class Sidebar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: _isExpanded ? 200 : 56, // Expanded vs collapsed width
      color: Colors.grey.shade100,
      child: Column(
        children: [
          // Toggle expand/collapse button at the top
          IconButton(
            icon: Icon(_isExpanded ? Icons.arrow_back : Icons.arrow_forward),
            onPressed: _toggleExpand,
            tooltip: _isExpanded ? 'Collapse' : 'Expand',
          ),
          const SizedBox(height: 8),

          // Sidebar items
          _SidebarItem(
            icon: Icons.explore,
            label: 'Explore',
            index: 0,
            selectedIndex: widget.selectedIndex,
            onTap: widget.onSelect,
            isExpanded: _isExpanded,
          ),
          _SidebarItem(
            icon: Icons.edit,
            label: 'Studio',
            index: 1,
            selectedIndex: widget.selectedIndex,
            onTap: widget.onSelect,
            isExpanded: _isExpanded,
          ),
          _SidebarItem(
            icon: Icons.shelves,
            label: 'Library',
            index: 2,
            selectedIndex: widget.selectedIndex,
            onTap: widget.onSelect,
            isExpanded: _isExpanded,
          ),
          _SidebarItem(
            icon: Icons.inventory,
            label: 'Marketplace',
            index: 3,
            selectedIndex: widget.selectedIndex,
            onTap: widget.onSelect,
            isExpanded: _isExpanded,
          ),
          _SidebarItem(
            icon: Icons.group,
            label: 'Collaboration',
            index: 4,
            selectedIndex: widget.selectedIndex,
            onTap: widget.onSelect,
            isExpanded: _isExpanded,
          ),

          const Spacer(),

          // Profile at the bottom
          ProfileItem(
            onTap: () {
              widget.onSelect(6); // switches to Profile page
            },
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final bool isExpanded;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = index == selectedIndex;

    return Tooltip(
      message: label,
      child: InkWell(
        onTap: () => onTap(index),
        child: Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: isExpanded ? 16 : 0),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 3,
                color: selected ? Colors.blue : Colors.transparent,
              ),
            ),
            color: selected
                ? Colors.blue.withOpacity(0.08)
                : Colors.transparent,
          ),
          child: isExpanded
              ? Row(
                  children: [
                    Icon(
                      icon,
                      color: selected ? Colors.blue : Colors.grey.shade700,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: TextStyle(
                        color: selected ? Colors.blue : Colors.grey.shade800,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Icon(
                    icon,
                    color: selected ? Colors.blue : Colors.grey.shade700,
                  ),
                ),
        ),
      ),
    );
  }
}
