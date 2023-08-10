enum STATUS {
  draft,
  investigating,
  escalated,
  resolved,
}

// These are the names of the statuses in the database
// for instance for this record:
// STATUS.draft: 'Draft',
const STATUS_NAMES = {
  STATUS.draft: 'Draft',
  STATUS.investigating: 'Investigating',
  STATUS.escalated: 'Escalated',
  STATUS.resolved: 'Resolved',
};

extension StatusExtension on STATUS {
  String get name => STATUS_NAMES[this]!;
}

List<STATUS> getAllStatuses() {
  return STATUS.values;
}

STATUS getStatusByKey(String name) {
  return STATUS_NAMES.entries
      .firstWhere((element) => element.key.toString().split('.')[1] == name)
      .key;
}

String getStatusKey(STATUS s) {
  return STATUS_NAMES.entries
      .firstWhere((element) => element.key == s)
      .key
      .toString()
      .split('.')[1];
}
