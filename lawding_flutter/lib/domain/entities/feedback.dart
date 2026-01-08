/// 피드백 타입
enum FeedbackCategory {
  errorReport,
  improvement,
  question,
  satisfaction,
  other;

  String get displayName {
    return switch (this) {
      FeedbackCategory.errorReport => '오류 신고',
      FeedbackCategory.improvement => '개선 제안',
      FeedbackCategory.question => '문의',
      FeedbackCategory.satisfaction => '만족도 평가',
      FeedbackCategory.other => '기타',
    };
  }
}

/// 피드백 정보를 나타내는 Domain Entity
class Feedback {
  /// 피드백 타입
  final FeedbackCategory category;

  /// 피드백 내용
  final String? content;

  /// 이메일
  final String? email;

  /// 별점 (1~5)
  final int? rating;

  /// 연차 계산 ID (연차 계산 결과에 대한 피드백인 경우)
  final String? calculationId;

  const Feedback({
    required this.category,
    this.content,
    this.email,
    this.rating,
    this.calculationId,
  });

  /// 별점이 유효한지 확인
  bool get hasValidRating => rating != null && rating! >= 1 && rating! <= 5;

  /// 내용이 있는지 확인
  bool get hasContent => content != null && content!.isNotEmpty;

  /// 이메일이 있는지 확인
  bool get hasEmail => email != null && email!.isNotEmpty;

  @override
  String toString() {
    return 'Feedback(category: ${category.displayName}, hasContent: $hasContent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Feedback &&
        other.category == category &&
        other.content == content &&
        other.email == email &&
        other.rating == rating &&
        other.calculationId == calculationId;
  }

  @override
  int get hashCode {
    return Object.hash(category, content, email, rating, calculationId);
  }
}
