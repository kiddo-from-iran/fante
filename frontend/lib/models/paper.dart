class Paper {
  final String authors;
  final int year;
  final String title;
  final String source;
  final String added;
  final String collection;

  Paper({
    required this.authors,
    required this.year,
    required this.title,
    required this.source,
    required this.added,
    required this.collection,
  });
}


final List<Paper> allPapers = [
  Paper(
    authors: 'Lin, Min3123gyuan',
    year: 2025,
    title: 'Non-Uniform Exposure Imaging...',
    source: 'IEEE TPAMI',
    added: '2/7/2026',
    collection: 'Books',
  ),
    Paper(
    authors: '23213, Mingyuan',
    year: 2025,
    title: 'Non-Uniform Exposure Imaging...',
    source: 'IEEE TPAMI',
    added: '2/7/2026',
    collection: 'Books',
  ),
];