enum NonWorkingType {
  parentalLeave,
  maternityLeave,
  miscarriageStillbirth,
  reserveForcesTraining,
  industrialAccident,
  civicDuty,
  spouseMaternityLeave,
  familyCareLeave,
  unfairDismissal,
  illegalLockout,
  unauthorizedAbsence,
  disciplinarySuspension,
  illegalStrike,
  militaryServiceLeave,
  personalIllnessLeave,
  personalReasonLeave,
}

extension NonWorkingTypeExtension on NonWorkingType {
  String get displayName {
    switch (this) {
      case NonWorkingType.parentalLeave:
        return '육아휴직';
      case NonWorkingType.maternityLeave:
        return '출산전후휴가';
      case NonWorkingType.miscarriageStillbirth:
        return '유사산휴가';
      case NonWorkingType.reserveForcesTraining:
        return '예비군훈련';
      case NonWorkingType.industrialAccident:
        return '산재 기간';
      case NonWorkingType.civicDuty:
        return '공민권 행사일';
      case NonWorkingType.spouseMaternityLeave:
        return '출산휴가';
      case NonWorkingType.familyCareLeave:
        return '가족돌봄휴가';
      case NonWorkingType.unfairDismissal:
        return '부당해고';
      case NonWorkingType.illegalLockout:
        return '직장폐쇄(불법)';
      case NonWorkingType.unauthorizedAbsence:
        return '무단결근';
      case NonWorkingType.disciplinarySuspension:
        return '징계 정·휴직 등';
      case NonWorkingType.illegalStrike:
        return '불법쟁의행위';
      case NonWorkingType.militaryServiceLeave:
        return '군 휴직';
      case NonWorkingType.personalIllnessLeave:
        return '개인 질병 휴직';
      case NonWorkingType.personalReasonLeave:
        return '일반휴직(개인사유)';
    }
  }

  int get serverCode {
    switch (this) {
      case NonWorkingType.parentalLeave:
      case NonWorkingType.maternityLeave:
      case NonWorkingType.miscarriageStillbirth:
      case NonWorkingType.reserveForcesTraining:
      case NonWorkingType.industrialAccident:
      case NonWorkingType.civicDuty:
      case NonWorkingType.spouseMaternityLeave:
      case NonWorkingType.familyCareLeave:
      case NonWorkingType.unfairDismissal:
      case NonWorkingType.illegalLockout:
        return 1;

      case NonWorkingType.unauthorizedAbsence:
      case NonWorkingType.disciplinarySuspension:
      case NonWorkingType.illegalStrike:
        return 2;

      case NonWorkingType.militaryServiceLeave:
      case NonWorkingType.personalIllnessLeave:
      case NonWorkingType.personalReasonLeave:
        return 3;
    }
  }

  static NonWorkingType? fromDisplayName(String displayName) {
    for (final type in NonWorkingType.values) {
      if (type.displayName == displayName) {
        return type;
      }
    }
    return null;
  }
}
