enum FeedbackType {
  errorReport,
  improvement,
  question,
  satisfaction,
  other,
}

extension FeedbackTypeMapper on FeedbackType {
  String toApiValue() {
    switch (this) {
      case FeedbackType.errorReport:
        return 'ERROR_REPORT';
      case FeedbackType.improvement:
        return 'IMPROVEMENT';
      case FeedbackType.question:
        return 'QUESTION';
      case FeedbackType.satisfaction:
        return 'SATISFACTION';
      case FeedbackType.other:
        return 'OTHER';
    }
  }
}

class FeedbackParams {
  final FeedbackType type;
  final String? content;
  final String? email;
  final int? rating;
  final String? calculationId;

  const FeedbackParams({
    required this.type,
    this.content,
    this.email,
    this.rating,
    this.calculationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toApiValue(),
      if (content != null) 'content': content,
      if (email != null) 'email': email,
      if (rating != null) 'rating': rating,
      if (calculationId != null) 'calculationId': calculationId,
    };
  }
}
