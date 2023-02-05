class Device {
  Device({
    required this.SKGSI1,
    required this.generation,
    required this.SKGSI2,
    required this.status,
    required this.name,
    required this.state,
    required this.v,
    required this.SK,
    required this.actual,
    required this.id,
    required this.batch,
    required this.model,
    required this.version,
    required this.creator,
    required this.manufactured,
    required this.config,
    required this.created,
    required this.updated,
    required this.deviceModel,
    required this.vComponent,
    required this.make,
    required this.base,
    required this.capabilities,
    required this.manufacturer,
    required this.PKGSI2,
    required this.orderState,
    required this.account,
    required this.PK,
    required this.PKGSI1,
    required this.type,
    required this.exposure,
  });
  late final String SKGSI1;
  late final String generation;
  late final String SKGSI2;
  late final Map<String, dynamic> status;
  late final String name;
  late final String state;
  late final String v;
  late final String SK;
  late final Map<String, dynamic> actual;
  late final String id;
  late final String batch;
  late final String model;
  late final String version;
  late final String creator;
  late final String manufactured;
  late final Map<String, dynamic> config;
  late final String created;
  late final String? updated;
  late final String deviceModel;
  late final String vComponent;
  late final String make;
  late final Map<String, dynamic> base;
  late final Map<String, dynamic> capabilities;
  late final String manufacturer;
  late final String PKGSI2;
  late final String orderState;
  late final String account;
  late final String PK;
  late final String PKGSI1;
  late final String type;
  late final String exposure;

  Device.fromJson(Map<String, dynamic> json) {
    SKGSI1 = json['SK_GSI1'];
    generation = json['generation'];
    SKGSI2 = json['SK_GSI2'];
    status = json['status'];
    name = json['name'];
    state = json['state'];
    v = json['v'];
    SK = json['SK'];
    actual = json['actual'];
    id = json['id'];
    batch = json['batch'];
    model = json['model'];
    version = json['version'];
    creator = json['creator'];
    manufactured = json['manufactured'];
    config = json['config'];
    created = json['created'];
    updated = json['updated'];
    deviceModel = json['deviceModel'];
    vComponent = json['v_Component'];
    make = json['make'];
    base = json['base'];
    capabilities = json['capabilities'];
    manufacturer = json['manufacturer'];
    PKGSI2 = json['PK_GSI2'];
    orderState = json['orderState'];
    account = json['account'];
    PK = json['PK'];
    PKGSI1 = json['PK_GSI1'];
    type = json['type'];
    exposure = json['exposure'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['SK_GSI1'] = SKGSI1;
    _data['generation'] = generation;
    _data['SK_GSI2'] = SKGSI2;
    _data['status'] = status;
    _data['name'] = name;
    _data['state'] = state;
    _data['v'] = v;
    _data['SK'] = SK;
    _data['actual'] = actual;
    _data['id'] = id;
    _data['batch'] = batch;
    _data['model'] = model;
    _data['version'] = version;
    _data['creator'] = creator;
    _data['manufactured'] = manufactured;
    _data['config'] = config;
    _data['created'] = created;
    _data['updated'] = updated;
    _data['deviceModel'] = deviceModel;
    _data['v_Component'] = vComponent;
    _data['make'] = make;
    _data['base'] = base;
    _data['capabilities'] = capabilities;
    _data['manufacturer'] = manufacturer;
    _data['PK_GSI2'] = PKGSI2;
    _data['orderState'] = orderState;
    _data['account'] = account;
    _data['PK'] = PK;
    _data['PK_GSI1'] = PKGSI1;
    _data['type'] = type;
    _data['exposure'] = exposure;
    return _data;
  }
}
