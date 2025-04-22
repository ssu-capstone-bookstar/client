class StatusResponse {
  final String resultCode;
  final String resultMessage;

  StatusResponse({
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
}
