abstract class DeviceInfoRepository {
  /// 실제 DeviceUUID와는 다르며, 첫 실행시에 생성된 랜덤 UUID를 반환합니다.
  Future<String> getDeviceId();
}
