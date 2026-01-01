import '../../domain/entities/feedback.dart' as domain;
import 'feedback_params.dart';

/// Domain Feedback을 Data FeedbackParams로 변환
extension FeedbackMapper on domain.Feedback {
  FeedbackParams toDataModel() {
    return FeedbackParams(
      type: category.toDataType(),
      content: content,
      email: email,
      rating: rating,
      calculationId: calculationId,
    );
  }
}

/// Domain FeedbackCategory를 Data FeedbackType으로 변환
extension FeedbackCategoryMapper on domain.FeedbackCategory {
  FeedbackType toDataType() {
    return switch (this) {
      domain.FeedbackCategory.errorReport => FeedbackType.errorReport,
      domain.FeedbackCategory.improvement => FeedbackType.improvement,
      domain.FeedbackCategory.question => FeedbackType.question,
      domain.FeedbackCategory.satisfaction => FeedbackType.satisfaction,
      domain.FeedbackCategory.other => FeedbackType.other,
    };
  }
}
