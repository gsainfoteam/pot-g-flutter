extension ListX<T> on List<T> {
  /// 연속된 요소만 그룹화하는 함수
  /// [list]: 그룹화할 리스트
  /// [keySelector]: 그룹화 기준이 되는 키를 추출하는 함수
  ///
  /// 예시: [1, 2, 13, 14, 4, 3, 23, 12]를 (x) => x % 10으로 그룹화하면
  /// [[1, 2], [13, 14], [4, 3], [23], [12]]가 됩니다.
  List<List<T>> groupConsecutiveBy<K>(K Function(T) keySelector) {
    if (isEmpty) return [];

    final result = <List<T>>[];
    List<T> currentGroup = [first];

    for (int i = 1; i < length; i++) {
      final currentItem = this[i];
      final previousItem = this[i - 1];

      // 현재 아이템과 이전 아이템의 키가 같으면 같은 그룹에 추가
      if (keySelector(currentItem) == keySelector(previousItem)) {
        currentGroup.add(currentItem);
      } else {
        // 키가 다르면 현재 그룹을 결과에 추가하고 새 그룹 시작
        result.add(List.from(currentGroup));
        currentGroup = [currentItem];
      }
    }

    // 마지막 그룹 추가
    result.add(currentGroup);

    return result;
  }
}
