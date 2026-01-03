// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dioClientHash() => r'1e01a172917b0cd3222effb0bdb534bf02f7346b';

/// DioClient Provider
/// 네트워크 통신을 위한 DioClient 인스턴스 제공
///
/// Copied from [dioClient].
@ProviderFor(dioClient)
final dioClientProvider = AutoDisposeProvider<DioClient>.internal(
  dioClient,
  name: r'dioClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dioClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DioClientRef = AutoDisposeProviderRef<DioClient>;
String _$annualLeaveRepositoryHash() =>
    r'c853c76be9de247327bf0af1ca1dd380621e29f3';

/// AnnualLeaveRepository Provider
/// 연차 계산 Repository 구현체 제공
///
/// Copied from [annualLeaveRepository].
@ProviderFor(annualLeaveRepository)
final annualLeaveRepositoryProvider =
    AutoDisposeProvider<AnnualLeaveRepository>.internal(
      annualLeaveRepository,
      name: r'annualLeaveRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$annualLeaveRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnnualLeaveRepositoryRef =
    AutoDisposeProviderRef<AnnualLeaveRepository>;
String _$feedbackRepositoryHash() =>
    r'c53d8b8e5f76b60c08b097ff839517bded365a4f';

/// FeedbackRepository Provider
/// 피드백 제출 Repository 구현체 제공
///
/// Copied from [feedbackRepository].
@ProviderFor(feedbackRepository)
final feedbackRepositoryProvider =
    AutoDisposeProvider<FeedbackRepository>.internal(
      feedbackRepository,
      name: r'feedbackRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$feedbackRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeedbackRepositoryRef = AutoDisposeProviderRef<FeedbackRepository>;
String _$calculateAnnualLeaveUseCaseHash() =>
    r'b8f17d7996bac3a788a250d5a3b68fe30b82be78';

/// CalculateAnnualLeaveUseCase Provider
/// 연차 계산 비즈니스 로직 제공
///
/// Copied from [calculateAnnualLeaveUseCase].
@ProviderFor(calculateAnnualLeaveUseCase)
final calculateAnnualLeaveUseCaseProvider =
    AutoDisposeProvider<CalculateAnnualLeaveUseCase>.internal(
      calculateAnnualLeaveUseCase,
      name: r'calculateAnnualLeaveUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$calculateAnnualLeaveUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CalculateAnnualLeaveUseCaseRef =
    AutoDisposeProviderRef<CalculateAnnualLeaveUseCase>;
String _$submitFeedbackUseCaseHash() =>
    r'b26b98a123da817ae8cef5481ac1e53588802608';

/// SubmitFeedbackUseCase Provider
/// 피드백 제출 비즈니스 로직 제공
///
/// Copied from [submitFeedbackUseCase].
@ProviderFor(submitFeedbackUseCase)
final submitFeedbackUseCaseProvider =
    AutoDisposeProvider<SubmitFeedbackUseCase>.internal(
      submitFeedbackUseCase,
      name: r'submitFeedbackUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$submitFeedbackUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubmitFeedbackUseCaseRef =
    AutoDisposeProviderRef<SubmitFeedbackUseCase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
