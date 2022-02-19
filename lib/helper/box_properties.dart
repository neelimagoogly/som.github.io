class BoxProperties {
  String id;
  int orderIndex;
  int shuffleIndex;
  String mathValue, wordValue;
  bool isTarget;
  BoxProperties({
    required this.id,
    required this.orderIndex,
    required this.shuffleIndex,
    required this.mathValue,
    required this.wordValue,
    required this.isTarget,
  });

  BoxProperties.clone(BoxProperties props)
      : this(
          id: props.id,
          orderIndex: props.orderIndex,
          shuffleIndex: props.shuffleIndex,
          mathValue: props.mathValue,
          wordValue: props.wordValue,
          isTarget: props.isTarget,
        );
}
