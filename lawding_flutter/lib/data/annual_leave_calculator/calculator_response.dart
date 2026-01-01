class CalculatorResponse {
  final int totalAnnualLeaves;
  final int usedAnnualLeaves;
  final int remainingAnnualLeaves;
  final String calculationId;
  final String hireDate;
  final String referenceDate;

  const CalculatorResponse({
    required this.totalAnnualLeaves,
    required this.usedAnnualLeaves,
    required this.remainingAnnualLeaves,
    required this.calculationId,
    required this.hireDate,
    required this.referenceDate,
  });

  factory CalculatorResponse.fromJson(Map<String, dynamic> json) {
    return CalculatorResponse(
      totalAnnualLeaves: json['totalAnnualLeaves'] as int,
      usedAnnualLeaves: json['usedAnnualLeaves'] as int,
      remainingAnnualLeaves: json['remainingAnnualLeaves'] as int,
      calculationId: json['calculationId'] as String,
      hireDate: json['hireDate'] as String,
      referenceDate: json['referenceDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAnnualLeaves': totalAnnualLeaves,
      'usedAnnualLeaves': usedAnnualLeaves,
      'remainingAnnualLeaves': remainingAnnualLeaves,
      'calculationId': calculationId,
      'hireDate': hireDate,
      'referenceDate': referenceDate,
    };
  }
}
