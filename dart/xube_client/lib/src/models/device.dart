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
  late final Status status;
  late final String name;
  late final String state;
  late final String v;
  late final String SK;
  late final Actual actual;
  late final String id;
  late final String batch;
  late final String model;
  late final String version;
  late final String creator;
  late final String manufactured;
  late final Config config;
  late final String created;
  late final String deviceModel;
  late final String vComponent;
  late final String make;
  late final Base base;
  late final Capabilities capabilities;
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
    status = Status.fromJson(json['status']);
    name = json['name'];
    state = json['state'];
    v = json['v'];
    SK = json['SK'];
    actual = Actual.fromJson(json['actual']);
    id = json['id'];
    batch = json['batch'];
    model = json['model'];
    version = json['version'];
    creator = json['creator'];
    manufactured = json['manufactured'];
    config = Config.fromJson(json['config']);
    created = json['created'];
    deviceModel = json['deviceModel'];
    vComponent = json['v_Component'];
    make = json['make'];
    base = Base.fromJson(json['base']);
    capabilities = Capabilities.fromJson(json['capabilities']);
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
    _data['status'] = status.toJson();
    _data['name'] = name;
    _data['state'] = state;
    _data['v'] = v;
    _data['SK'] = SK;
    _data['actual'] = actual.toJson();
    _data['id'] = id;
    _data['batch'] = batch;
    _data['model'] = model;
    _data['version'] = version;
    _data['creator'] = creator;
    _data['manufactured'] = manufactured;
    _data['config'] = config.toJson();
    _data['created'] = created;
    _data['deviceModel'] = deviceModel;
    _data['v_Component'] = vComponent;
    _data['make'] = make;
    _data['base'] = base.toJson();
    _data['capabilities'] = capabilities.toJson();
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

class Status {
  Status({
    required this.current,
    required this.expected,
  });
  late final Current current;
  late final Expected expected;

  Status.fromJson(Map<String, dynamic> json) {
    current = Current.fromJson(json['current']);
    expected = Expected.fromJson(json['expected']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['current'] = current.toJson();
    _data['expected'] = expected.toJson();
    return _data;
  }
}

class Current {
  Current();

  Current.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}

class Expected {
  Expected({
    required this.system,
  });
  late final System system;

  Expected.fromJson(Map<String, dynamic> json) {
    system = System.fromJson(json['system']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['system'] = system.toJson();
    return _data;
  }
}

class System {
  System({
    required this.a,
  });
  late final int a;

  System.fromJson(Map<String, dynamic> json) {
    a = json['a'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['a'] = a;
    return _data;
  }
}

class Actual {
  Actual({
    required this.schema,
    required this.config,
    required this.connections,
  });
  late final Schema schema;
  late final Config config;
  late final Connections connections;

  Actual.fromJson(Map<String, dynamic> json) {
    schema = Schema.fromJson(json['schema']);
    config = Config.fromJson(json['config']);
    connections = Connections.fromJson(json['connections']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['schema'] = schema.toJson();
    _data['config'] = config.toJson();
    _data['connections'] = connections.toJson();
    return _data;
  }
}

class Schema {
  Schema();

  Schema.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}

class Config {
  Config();

  Config.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}

class Connections {
  Connections();

  Connections.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}

class Base {
  Base({
    required this.configuredVersion,
    required this.componentID,
    required this.originalVersion,
  });
  late final String configuredVersion;
  late final String componentID;
  late final String originalVersion;

  Base.fromJson(Map<String, dynamic> json) {
    configuredVersion = json['configuredVersion'];
    componentID = json['componentID'];
    originalVersion = json['originalVersion'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['configuredVersion'] = configuredVersion;
    _data['componentID'] = componentID;
    _data['originalVersion'] = originalVersion;
    return _data;
  }
}

class Capabilities {
  Capabilities();

  Capabilities.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}
