class Group {
  Group({
    required this.links,
    required this.updater,
    required this.updates,
    required this.version,
    required this.SKGSI1,
    required this.creator,
    required this.config,
    required this.status,
    required this.created,
    required this.name,
    required this.vComponent,
    required this.state,
    required this.updated,
    required this.v,
    required this.account,
    required this.SK,
    required this.PK,
    required this.PKGSI1,
    required this.id,
    required this.exposure,
    required this.type,
  });

  late final dynamic links;
  late final String? updater;
  late final dynamic updates;
  late final String? version;
  late final String? SKGSI1;
  late final String? creator;
  late final dynamic config;
  late final String? status;
  late final String? created;
  late final String? name;
  late final String? vComponent;
  late final String? state;
  late final String? updated;
  late final String? v;
  late final String? account;
  late final String? SK;
  late final String? PK;
  late final String? PKGSI1;
  late final String? id;
  late final String? exposure;
  late final String? type;

  Group.fromJson(Map<String, dynamic> json) {
    // links = List.from(json['links']).map((e) => Links.fromJson(e)).toList();
    links = json['links'];
    updater = json['updater'];
    // updates =
    //     List.from(json['updates']).map((e) => Updates.fromJson(e)).toList();
    updates = json['updated'];
    version = json['version'];
    SKGSI1 = json['SK_GSI1'];
    creator = json['creator'];
    // config = Config.fromJson(json['config']);
    config = json['config'];
    status = json['status'];
    created = json['created'];
    name = json['name'];
    vComponent = json['v_Component'];
    state = json['state'];
    updated = json['updated'];
    v = json['v'];
    account = json['account'];
    SK = json['SK'];
    PK = json['PK'];
    PKGSI1 = json['PK_GSI1'];
    id = json['id'];
    exposure = json['exposure'];
    type = json['type'];
  }

  Map<String?, dynamic> toJson() {
    final _data = <String, dynamic>{};
    // _data['links'] = links.map((e) => e.toJson()).toList();
    _data['links'] = links;
    _data['updater'] = updater;
    // _data['updates'] = updates.map((e) => e.toJson()).toList();
    _data['updates'] = updates;
    _data['version'] = version;
    _data['SK_GSI1'] = SKGSI1;
    _data['creator'] = creator;
    // _data['config'] = config.toJson();
    _data['config'] = config;
    _data['status'] = status;
    _data['created'] = created;
    _data['name'] = name;
    _data['v_Component'] = vComponent;
    _data['state'] = state;
    _data['updated'] = updated;
    _data['v'] = v;
    _data['account'] = account;
    _data['SK'] = SK;
    _data['PK'] = PK;
    _data['PK_GSI1'] = PKGSI1;
    _data['id'] = id;
    _data['exposure'] = exposure;
    _data['type'] = type;
    return _data;
  }
}
