class AppUsageInfo {
  final String packageName;
  final int totalTimeInForeground;
  final int lastTimeUsed;

  AppUsageInfo({
    required this.packageName,
    required this.totalTimeInForeground,
    required this.lastTimeUsed,
  });

  factory AppUsageInfo.fromMap(Map<String, dynamic> map) {
    return AppUsageInfo(
      packageName: map['packageName'],
      totalTimeInForeground: map['totalTimeInForeground'],
      lastTimeUsed: map['lastTimeUsed'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'packageName': packageName,
      'totalTimeInForeground': totalTimeInForeground.toString(),
      'lastTimeUsed': lastTimeUsed.toString(),
    };
  }
}
