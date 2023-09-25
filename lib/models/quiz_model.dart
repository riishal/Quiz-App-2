class QuizModel {
  final int id;
  final String question;
  final List<String> choices;
  final String answer;
  int selectedIndex;

  QuizModel({
    required this.id,
    required this.question,
    required this.choices,
    required this.answer,
    required this.selectedIndex,
  });
}
