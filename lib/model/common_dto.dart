import 'package:bookstar_app/model/status_response_dto.dart';

class CommonDto<T> {
  final StatusResponse statusResponse;
  final T data;

  CommonDto({
    required this.statusResponse,
    required this.data,
  });

  factory CommonDto.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromDataJson,
  ) {
    return CommonDto(
      statusResponse: StatusResponse.fromJson(json['statusResponse']),
      data: fromDataJson(json['data']),
    );
  }

  Map<String, dynamic> toJson(
    Map<String, dynamic> Function(T data) toDataJson,
  ) {
    return {
      'statusResponse': statusResponse.toJson(),
      'data': toDataJson(data),
    };
  }
}
