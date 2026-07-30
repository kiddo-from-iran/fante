/// High-level game formats supported by the platform UI.
enum GameKind {
  quiz,
  poll,
  personality,
}

/// Result presentation variants — a creator can pick one per game type.
enum GameResultVariant {
  /// Poll / survey results with percentage bars.
  pollBars,

  /// Standard quiz score with stars, XP and rank.
  quizScore,

  /// Personality / world-discovery layout with image grid.
  worldDiscovery,
}

/// Maps a [GameKind] to its default result variant for demo routes.
extension GameKindResult on GameKind {
  GameResultVariant get defaultResultVariant {
    switch (this) {
      case GameKind.quiz:
        return GameResultVariant.quizScore;
      case GameKind.poll:
        return GameResultVariant.pollBars;
      case GameKind.personality:
        return GameResultVariant.worldDiscovery;
    }
  }
}
