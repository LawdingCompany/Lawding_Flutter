# 테스트 가이드

이 문서는 Flutter 프로젝트의 네트워크 레이어 테스트 실행 방법을 설명합니다.

## 목차
- [테스트 구조](#테스트-구조)
- [테스트 실행 방법](#테스트-실행-방법)
- [작성된 테스트 케이스](#작성된-테스트-케이스)
- [테스트 코드 작성 가이드](#테스트-코드-작성-가이드)

---

## 테스트 구조

```
test/
├── data/
│   ├── annual_leave_calculator/
│   │   └── calculator_repository_test.dart    # 연차 계산 API 테스트
│   └── feedback/
│       └── feedback_repository_test.dart      # 피드백 API 테스트
├── helpers/
│   └── mock_dio_helper.dart                   # Mock HTTP 응답 헬퍼
└── README.md                                  # 이 문서
```

---

## 테스트 실행 방법

### 1. 전체 테스트 실행

프로젝트 루트 디렉토리에서 아래 명령어를 실행합니다:

```bash
flutter test
```

### 2. 특정 테스트 파일만 실행

```bash
# 연차 계산 API 테스트만 실행
flutter test test/data/annual_leave_calculator/calculator_repository_test.dart

# 피드백 API 테스트만 실행
flutter test test/data/feedback/feedback_repository_test.dart
```

### 3. 특정 테스트 케이스만 실행

테스트 파일 내에서 특정 테스트만 실행하려면 `--name` 옵션을 사용합니다:

```bash
# "성공"이라는 단어가 포함된 테스트만 실행
flutter test --name "성공"

# "에러"가 포함된 테스트만 실행
flutter test --name "에러"
```

### 4. 테스트 커버리지 확인

코드 커버리지를 확인하려면:

```bash
flutter test --coverage
```

생성된 커버리지 리포트를 확인:

```bash
# macOS/Linux
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# 또는 VS Code Extension 사용
# Flutter Coverage Gutters 확장 설치 후 사용
```

### 5. Watch 모드로 테스트 실행

파일이 변경될 때마다 자동으로 테스트를 실행:

```bash
flutter test --watch
```

### 6. VS Code에서 테스트 실행

1. 테스트 파일을 엽니다
2. 테스트 함수 위의 `Run` 또는 `Debug` 링크를 클릭
3. 또는 `Cmd+Shift+P` (Mac) / `Ctrl+Shift+P` (Windows)를 눌러 `Flutter: Run Tests` 선택

### 7. Android Studio / IntelliJ에서 테스트 실행

1. 테스트 파일을 열거나 프로젝트 탐색기에서 선택
2. 테스트 함수 왼쪽의 재생 버튼을 클릭
3. 또는 `Ctrl+Shift+R` (Mac) / `Ctrl+Shift+F10` (Windows)

---

## 작성된 테스트 케이스

### CalculatorRepository 테스트

**파일**: `test/data/annual_leave_calculator/calculator_repository_test.dart`

| 테스트 케이스 | 설명 |
|------------|------|
| 연차 계산 성공 - 정상적인 응답 | 정상적인 API 응답 시 CalculatorResponse 반환 확인 |
| 연차 계산 성공 - 비근무 기간 포함 | 비근무 기간이 있는 복잡한 케이스 처리 확인 |
| 연차 계산 실패 - 서버 에러 (500) | 서버 에러 발생 시 ServerError 예외 처리 확인 |
| 연차 계산 실패 - 인증 에러 (401) | 인증 실패 시 UnauthorizedError 예외 처리 확인 |
| 연차 계산 실패 - 타임아웃 | 네트워크 타임아웃 시 TimeoutError 예외 처리 확인 |

### FeedbackRepository 테스트

**파일**: `test/data/feedback/feedback_repository_test.dart`

| 테스트 케이스 | 설명 |
|------------|------|
| 피드백 제출 성공 - 에러 리포트 | errorReport 타입 피드백 제출 성공 확인 |
| 피드백 제출 성공 - 만족도 평가 | satisfaction 타입 + 별점 포함 피드백 성공 확인 |
| 피드백 제출 성공 - 개선 제안 | improvement 타입 피드백 제출 성공 확인 |
| 피드백 제출 성공 - 질문 | question 타입 최소 정보로 제출 성공 확인 |
| 피드백 제출 성공 - 기타 | other 타입 피드백 제출 성공 확인 |
| 피드백 제출 실패 - 서버 에러 (500) | 서버 에러 시 예외 처리 확인 |
| 피드백 제출 실패 - 인증 에러 (401) | 인증 실패 시 예외 처리 확인 |
| 피드백 제출 실패 - 타임아웃 | 타임아웃 시 예외 처리 확인 |
| 피드백 제출 실패 - 잘못된 요청 (400) | Bad Request 시 예외 처리 확인 |

---

## 테스트 코드 작성 가이드

### 1. 테스트 구조 (AAA 패턴)

모든 테스트는 **Arrange-Act-Assert** 패턴을 따릅니다:

```dart
test('테스트 설명', () async {
  // Given (Arrange): 테스트 준비
  final params = SomeParams(...);
  mockDioHelper.mockPost(path: '...', responseData: {...});

  // When (Act): 실제 동작 실행
  final result = await repository.someMethod(params);

  // Then (Assert): 결과 검증
  expect(result.someField, expectedValue);
});
```

### 2. Mock 응답 설정하기

`MockDioHelper`를 사용하여 HTTP 응답을 시뮬레이션:

```dart
// 성공 응답
mockDioHelper.mockPost(
  path: '/api/endpoint',
  responseData: {'key': 'value'},
  statusCode: 200,
);

// 에러 응답
mockDioHelper.mockError(
  path: '/api/endpoint',
  method: 'POST',
  statusCode: 500,
  errorMessage: 'Error message',
);

// 타임아웃
mockDioHelper.mockTimeout(
  path: '/api/endpoint',
  method: 'POST',
);
```

### 3. 예외 테스트

예외가 발생하는 경우를 테스트:

```dart
test('실패 케이스', () async {
  // Given
  mockDioHelper.mockError(...);

  // When & Then
  expect(
    () => repository.someMethod(params),
    throwsA(isA<SomeErrorType>()),
  );
});
```

### 4. 새로운 테스트 추가하기

1. 적절한 디렉토리에 `*_test.dart` 파일 생성
2. `group()` 으로 관련 테스트들을 그룹화
3. `setUp()`에서 공통 초기화 코드 작성
4. 각 `test()`에서 개별 테스트 케이스 작성

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyClass Tests', () {
    late MyClass myClass;

    setUp(() {
      myClass = MyClass();
    });

    test('should do something', () {
      // 테스트 작성
    });
  });
}
```

---

## 테스트 Best Practices

1. **명확한 테스트 이름**: 테스트가 무엇을 검증하는지 명확하게 작성
2. **독립성**: 각 테스트는 다른 테스트에 의존하지 않아야 함
3. **단일 책임**: 하나의 테스트는 하나의 동작만 검증
4. **가독성**: Given-When-Then 주석으로 테스트 의도 명확히
5. **Edge Cases**: 성공 케이스뿐만 아니라 실패 케이스도 테스트

---

## 문제 해결

### 의존성 에러

```bash
flutter pub get
```

### 빌드 에러

```bash
flutter clean
flutter pub get
```

### 특정 테스트가 실패하는 경우

1. 테스트 로그를 자세히 확인
2. Mock 설정이 올바른지 확인
3. 경로(path)가 정확한지 확인
4. 예상 데이터 구조와 실제 응답이 일치하는지 확인

---

## 추가 리소스

- [Flutter 테스트 공식 문서](https://docs.flutter.dev/testing)
- [Mockito 문서](https://pub.dev/packages/mockito)
- [http_mock_adapter 문서](https://pub.dev/packages/http_mock_adapter)
