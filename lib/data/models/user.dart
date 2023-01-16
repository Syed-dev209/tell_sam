import 'dart:convert';

class UserModel {
  final String name;
  final String pin;
  bool sessionStarted;
  DateTime? sessionStartTime;
  DateTime? sessionEndTime;
  UserModel({
    required this.name,
    required this.pin,
    required this.sessionStarted,
    required this.sessionStartTime,
    required this.sessionEndTime,
  });

  UserModel copyWith({
    String? name,
    String? pin,
    bool? sessionStarted,
    DateTime? sessionStartTime,
    DateTime? sessionEndTime,
  }) {
    return UserModel(
      name: name ?? this.name,
      pin: pin ?? this.pin,
      sessionStarted: sessionStarted ?? this.sessionStarted,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      sessionEndTime: sessionEndTime ?? this.sessionEndTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'pin': pin,
      'sessionStarted': sessionStarted,
      'sessionStartTime': sessionStartTime?.millisecondsSinceEpoch,
      'sessionEndTime': sessionEndTime?.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      pin: map['pin'] ?? '',
      sessionStarted: map['sessionStarted'] ?? false,
      sessionStartTime: map['sessionStartTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['sessionStartTime'])
          : null,
      sessionEndTime: map['sessionEndTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['sessionEndTime'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, pin: $pin, sessionStarted: $sessionStarted, sessionStartTime: $sessionStartTime, sessionEndTime: $sessionEndTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.pin == pin &&
        other.sessionStarted == sessionStarted &&
        other.sessionStartTime == sessionStartTime &&
        other.sessionEndTime == sessionEndTime;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        pin.hashCode ^
        sessionStarted.hashCode ^
        sessionStartTime.hashCode ^
        sessionEndTime.hashCode;
  }
}
