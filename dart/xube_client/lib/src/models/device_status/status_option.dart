enum StatusOption {
  general,
  error,
  warning,
  waiting,
  healthy,
  ok,
}

StatusOption statusOptionFromJson(dynamic value) {
  value = value.toString().toLowerCase();

  final statusOptionList =
      StatusOption.values.map((statusOption) => statusOption.name).toList();
  if (statusOptionList.contains(value)) {
    return StatusOption.values.byName(value);
  }
  return StatusOption.general;
}

StatusOption getOverallState(List<StatusOption> states) {
  var state = StatusOption.healthy;

  for (var element in states) {
    if (element == StatusOption.error) {
      return StatusOption.error;
    }

    if (element == StatusOption.warning) {
      state = StatusOption.warning;
    }
  }

  return state;
}
