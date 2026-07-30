import 'package:flutter/material.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage>
    with TickerProviderStateMixin {
  int selectedTab = 0;

  final tabs = const ['Marketplace', 'Inventory', 'Packages'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Header
          const Text(
            "Plugin & Agent Marketplace",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            "Browse, install, and manage AI agents and research plugins",
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),

          // Tabs
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final selected = index == selectedTab;
                return InkWell(
                  onTap: () => setState(() => selectedTab = index),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Tab content
          Expanded(
            child: IndexedStack(
              index: selectedTab,
              children: const [
                _MarketplaceTab(),
                _InventoryTab(),
                _PackagesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------
/// Marketplace Tab
/// ------------------------
class _MarketplaceTab extends StatelessWidget {
  const _MarketplaceTab();

  @override
  Widget build(BuildContext context) {
    final plugins = const [
      _PluginCardData(
        name: "Citation Manager",
        description: "Automatically format and manage citations.",
        price: "Free",
        isFree: true,
        icon: Icons.menu_book,
      ),
      _PluginCardData(
        name: "AI Literature Review",
        description: "Generate structured literature reviews instantly.",
        price: "\$12/mo",
        icon: Icons.psychology,
      ),
      _PluginCardData(
        name: "Data Analyzer",
        description: "Analyze datasets and generate insights.",
        price: "\$19/mo",
        icon: Icons.bar_chart,
      ),
      _PluginCardData(
        name: "Collaboration Hub",
        description: "Real-time research collaboration tools.",
        price: "\$15/mo",
        icon: Icons.group,
      ),
      _PluginCardData(
        name: "PDF Smart Reader",
        description: "Annotate and extract key insights from PDFs.",
        price: "Free",
        isFree: true,
        icon: Icons.picture_as_pdf,
      ),
      _PluginCardData(
        name: "Grant Proposal Assistant",
        description: "Generate funding proposals efficiently.",
        price: "\$25/mo",
        icon: Icons.description,
      ),
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: plugins.length,
      itemBuilder: (context, index) {
        final plugin = plugins[index];
        return _PluginCard(plugin: plugin);
      },
    );
  }
}

/// ------------------------
/// Inventory Tab
/// ------------------------
class _InventoryTab extends StatelessWidget {
  const _InventoryTab();

  @override
  Widget build(BuildContext context) {
    final installedPlugins = const [
      _PluginCardData(
        name: "Citation Manager",
        description: "Installed",
        price: "Free",
        isFree: true,
        icon: Icons.menu_book,
      ),
      _PluginCardData(
        name: "PDF Smart Reader",
        description: "Installed",
        price: "Free",
        isFree: true,
        icon: Icons.picture_as_pdf,
      ),
    ];

    return ListView.separated(
      itemCount: installedPlugins.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final plugin = installedPlugins[index];
        return _InstalledPluginCard(plugin: plugin);
      },
    );
  }
}

/// ------------------------
/// Packages Tab
/// ------------------------
class _PackagesTab extends StatelessWidget {
  const _PackagesTab();

  @override
  Widget build(BuildContext context) {
    final packages = const [
      _PackageCardData(
        name: "Basic",
        price: "\$9/mo",
        description: "Solo researcher",
        features: [
          "5 core agents",
          "Basic AI tools",
          "Limited plugin access",
        ],
      ),
      _PackageCardData(
        name: "Premium",
        price: "\$29/mo",
        description: "Solo or small team",
        features: [
          "All writing agents",
          "Advanced citation tools",
          "Full plugin access",
          "Priority processing",
        ],
        highlighted: true,
      ),
      _PackageCardData(
        name: "Diamond",
        price: "\$79/mo",
        description: "Community & research groups",
        features: [
          "All agents & capabilities",
          "Team collaboration tools",
          "Unlimited plugins",
          "Dedicated AI resources",
        ],
      ),
    ];

    return ListView(
      scrollDirection: Axis.horizontal,
      children: packages
          .map((p) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _PackageCard(package: p),
              ))
          .toList(),
    );
  }
}

/// ------------------------
/// Plugin Card Models & Widgets
/// ------------------------
class _PluginCardData {
  final String name;
  final String description;
  final String price;
  final bool isFree;
  final IconData icon;

  const _PluginCardData({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    this.isFree = false,
  });
}

class _PluginCard extends StatelessWidget {
  final _PluginCardData plugin;

  const _PluginCard({required this.plugin});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(plugin.icon, size: 40),
            const SizedBox(height: 16),
            Text(
              plugin.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              plugin.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  plugin.price,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: plugin.isFree
                        ? Colors.green
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(plugin.isFree ? "Install" : "Subscribe"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InstalledPluginCard extends StatelessWidget {
  final _PluginCardData plugin;

  const _InstalledPluginCard({required this.plugin});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(plugin.icon, size: 36),
        title: Text(plugin.name),
        subtitle: Text(plugin.description),
        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text("Open"),
        ),
      ),
    );
  }
}

/// ------------------------
/// Package Card Models & Widgets
/// ------------------------
class _PackageCardData {
  final String name;
  final String price;
  final String description;
  final List<String> features;
  final bool highlighted;

  const _PackageCardData({
    required this.name,
    required this.price,
    required this.description,
    required this.features,
    this.highlighted = false,
  });
}

class _PackageCard extends StatelessWidget {
  final _PackageCardData package;

  const _PackageCard({required this.package});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: package.highlighted
            ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: package.highlighted
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade200,
          width: package.highlighted ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(package.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(package.price,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(package.description, style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          ...package.features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check, size: 16),
                    const SizedBox(width: 6),
                    Expanded(child: Text(f)),
                  ],
                ),
              )),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Choose Plan"),
            ),
          )
        ],
      ),
    );
  }
}
