/// A conversation with Ask, as it is kept: what was asked, in which
/// language, and when.
///
/// Only the questions are stored. Answers are worked out again from the plan
/// whenever the conversation is shown, so an old conversation never shows a
/// figure the plan no longer holds; the chat says so when it reopens one.
library;

class ChatTurn {
  const ChatTurn({
    required this.question,
    required this.askedAt,
    this.language,
  });

  final String question;
  final DateTime askedAt;

  /// The language the question was written in, when it differs from the
  /// app's, so the reply comes back in it.
  final String? language;
}

class Conversation {
  const Conversation({
    required this.id,
    required this.startedAt,
    this.turns = const [],
  });

  final String id;
  final DateTime startedAt;
  final List<ChatTurn> turns;

  /// What the list of conversations calls it: its first question.
  String? get title => turns.isEmpty ? null : turns.first.question;

  Conversation withTurn(ChatTurn turn) =>
      Conversation(id: id, startedAt: startedAt, turns: [...turns, turn]);
}
