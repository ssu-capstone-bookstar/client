import 'package:equatable/equatable.dart';

class StatusResponse extends Equatable {
  final String resultCode;
  final String resultMessage;

  const StatusResponse({
    required this.resultCode,
    required this.resultMessage,
  });

  factory StatusResponse.fromJson(Map<String, dynamic> json) {
    return StatusResponse(
      resultCode: json['resultCode'] ?? '',
      resultMessage: json['resultMessage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultCode': resultCode,
      'resultMessage': resultMessage,
    };
  }

  @override
  List<Object?> get props => [
        resultCode,
        resultMessage,
      ];
}
