// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CampgroundsTable extends Campgrounds
    with TableInfo<$CampgroundsTable, Campground> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CampgroundsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CampgroundKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CampgroundKind>($CampgroundsTable.$converterkind);
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 2,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    check: () => ComparableExpr(rating).isBetweenValues(1, 5),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wouldReturnMeta = const VerificationMeta(
    'wouldReturn',
  );
  @override
  late final GeneratedColumn<bool> wouldReturn = GeneratedColumn<bool>(
    'would_return',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("would_return" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'lon',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    kind,
    state,
    notes,
    rating,
    wouldReturn,
    lat,
    lon,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'campgrounds';
  @override
  VerificationContext validateIntegrity(
    Insertable<Campground> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('would_return')) {
      context.handle(
        _wouldReturnMeta,
        wouldReturn.isAcceptableOrUnknown(
          data['would_return']!,
          _wouldReturnMeta,
        ),
      );
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['lon']!, _lonMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Campground map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Campground(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $CampgroundsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      wouldReturn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}would_return'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lon'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CampgroundsTable createAlias(String alias) {
    return $CampgroundsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CampgroundKind, String, String> $converterkind =
      const EnumNameConverter<CampgroundKind>(CampgroundKind.values);
}

class Campground extends DataClass implements Insertable<Campground> {
  final int id;
  final String name;
  final CampgroundKind kind;
  final String? state;
  final String? notes;
  final int? rating;
  final bool wouldReturn;
  final double? lat;
  final double? lon;
  final DateTime createdAt;
  const Campground({
    required this.id,
    required this.name,
    required this.kind,
    this.state,
    this.notes,
    this.rating,
    required this.wouldReturn,
    this.lat,
    this.lon,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<String>(
        $CampgroundsTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<int>(rating);
    }
    map['would_return'] = Variable<bool>(wouldReturn);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lon != null) {
      map['lon'] = Variable<double>(lon);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CampgroundsCompanion toCompanion(bool nullToAbsent) {
    return CampgroundsCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      wouldReturn: Value(wouldReturn),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lon: lon == null && nullToAbsent ? const Value.absent() : Value(lon),
      createdAt: Value(createdAt),
    );
  }

  factory Campground.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Campground(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: $CampgroundsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      state: serializer.fromJson<String?>(json['state']),
      notes: serializer.fromJson<String?>(json['notes']),
      rating: serializer.fromJson<int?>(json['rating']),
      wouldReturn: serializer.fromJson<bool>(json['wouldReturn']),
      lat: serializer.fromJson<double?>(json['lat']),
      lon: serializer.fromJson<double?>(json['lon']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(
        $CampgroundsTable.$converterkind.toJson(kind),
      ),
      'state': serializer.toJson<String?>(state),
      'notes': serializer.toJson<String?>(notes),
      'rating': serializer.toJson<int?>(rating),
      'wouldReturn': serializer.toJson<bool>(wouldReturn),
      'lat': serializer.toJson<double?>(lat),
      'lon': serializer.toJson<double?>(lon),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Campground copyWith({
    int? id,
    String? name,
    CampgroundKind? kind,
    Value<String?> state = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<int?> rating = const Value.absent(),
    bool? wouldReturn,
    Value<double?> lat = const Value.absent(),
    Value<double?> lon = const Value.absent(),
    DateTime? createdAt,
  }) => Campground(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    state: state.present ? state.value : this.state,
    notes: notes.present ? notes.value : this.notes,
    rating: rating.present ? rating.value : this.rating,
    wouldReturn: wouldReturn ?? this.wouldReturn,
    lat: lat.present ? lat.value : this.lat,
    lon: lon.present ? lon.value : this.lon,
    createdAt: createdAt ?? this.createdAt,
  );
  Campground copyWithCompanion(CampgroundsCompanion data) {
    return Campground(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      state: data.state.present ? data.state.value : this.state,
      notes: data.notes.present ? data.notes.value : this.notes,
      rating: data.rating.present ? data.rating.value : this.rating,
      wouldReturn: data.wouldReturn.present
          ? data.wouldReturn.value
          : this.wouldReturn,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Campground(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('state: $state, ')
          ..write('notes: $notes, ')
          ..write('rating: $rating, ')
          ..write('wouldReturn: $wouldReturn, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    kind,
    state,
    notes,
    rating,
    wouldReturn,
    lat,
    lon,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Campground &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.state == this.state &&
          other.notes == this.notes &&
          other.rating == this.rating &&
          other.wouldReturn == this.wouldReturn &&
          other.lat == this.lat &&
          other.lon == this.lon &&
          other.createdAt == this.createdAt);
}

class CampgroundsCompanion extends UpdateCompanion<Campground> {
  final Value<int> id;
  final Value<String> name;
  final Value<CampgroundKind> kind;
  final Value<String?> state;
  final Value<String?> notes;
  final Value<int?> rating;
  final Value<bool> wouldReturn;
  final Value<double?> lat;
  final Value<double?> lon;
  final Value<DateTime> createdAt;
  const CampgroundsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.state = const Value.absent(),
    this.notes = const Value.absent(),
    this.rating = const Value.absent(),
    this.wouldReturn = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CampgroundsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required CampgroundKind kind,
    this.state = const Value.absent(),
    this.notes = const Value.absent(),
    this.rating = const Value.absent(),
    this.wouldReturn = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       kind = Value(kind);
  static Insertable<Campground> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<String>? state,
    Expression<String>? notes,
    Expression<int>? rating,
    Expression<bool>? wouldReturn,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (state != null) 'state': state,
      if (notes != null) 'notes': notes,
      if (rating != null) 'rating': rating,
      if (wouldReturn != null) 'would_return': wouldReturn,
      if (lat != null) 'lat': lat,
      if (lon != null) 'lon': lon,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CampgroundsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<CampgroundKind>? kind,
    Value<String?>? state,
    Value<String?>? notes,
    Value<int?>? rating,
    Value<bool>? wouldReturn,
    Value<double?>? lat,
    Value<double?>? lon,
    Value<DateTime>? createdAt,
  }) {
    return CampgroundsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      state: state ?? this.state,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      wouldReturn: wouldReturn ?? this.wouldReturn,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $CampgroundsTable.$converterkind.toSql(kind.value),
      );
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (wouldReturn.present) {
      map['would_return'] = Variable<bool>(wouldReturn.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['lon'] = Variable<double>(lon.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CampgroundsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('state: $state, ')
          ..write('notes: $notes, ')
          ..write('rating: $rating, ')
          ..write('wouldReturn: $wouldReturn, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SitesTable extends Sites with TableInfo<$SitesTable, Site> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SitesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _campgroundIdMeta = const VerificationMeta(
    'campgroundId',
  );
  @override
  late final GeneratedColumn<int> campgroundId = GeneratedColumn<int>(
    'campground_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES campgrounds (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _siteNoMeta = const VerificationMeta('siteNo');
  @override
  late final GeneratedColumn<String> siteNo = GeneratedColumn<String>(
    'site_no',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Amps, String> amps =
      GeneratedColumn<String>(
        'amps',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Amps>($SitesTable.$converteramps);
  static const VerificationMeta _waterMeta = const VerificationMeta('water');
  @override
  late final GeneratedColumn<bool> water = GeneratedColumn<bool>(
    'water',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("water" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sewerMeta = const VerificationMeta('sewer');
  @override
  late final GeneratedColumn<bool> sewer = GeneratedColumn<bool>(
    'sewer',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sewer" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _maxLengthFtMeta = const VerificationMeta(
    'maxLengthFt',
  );
  @override
  late final GeneratedColumn<int> maxLengthFt = GeneratedColumn<int>(
    'max_length_ft',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Approach?, String> approach =
      GeneratedColumn<String>(
        'approach',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Approach?>($SitesTable.$converterapproachn);
  @override
  late final GeneratedColumnWithTypeConverter<Shade?, String> shade =
      GeneratedColumn<String>(
        'shade',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Shade?>($SitesTable.$convertershaden);
  @override
  late final GeneratedColumnWithTypeConverter<Level?, String> level =
      GeneratedColumn<String>(
        'level',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Level?>($SitesTable.$converterleveln);
  static const VerificationMeta _cellBarsMeta = const VerificationMeta(
    'cellBars',
  );
  @override
  late final GeneratedColumn<int> cellBars = GeneratedColumn<int>(
    'cell_bars',
    aliasedName,
    true,
    check: () => ComparableExpr(cellBars).isBetweenValues(0, 5),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cellCarrierMeta = const VerificationMeta(
    'cellCarrier',
  );
  @override
  late final GeneratedColumn<String> cellCarrier = GeneratedColumn<String>(
    'cell_carrier',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    campgroundId,
    siteNo,
    amps,
    water,
    sewer,
    maxLengthFt,
    approach,
    shade,
    level,
    cellBars,
    cellCarrier,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sites';
  @override
  VerificationContext validateIntegrity(
    Insertable<Site> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('campground_id')) {
      context.handle(
        _campgroundIdMeta,
        campgroundId.isAcceptableOrUnknown(
          data['campground_id']!,
          _campgroundIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_campgroundIdMeta);
    }
    if (data.containsKey('site_no')) {
      context.handle(
        _siteNoMeta,
        siteNo.isAcceptableOrUnknown(data['site_no']!, _siteNoMeta),
      );
    } else if (isInserting) {
      context.missing(_siteNoMeta);
    }
    if (data.containsKey('water')) {
      context.handle(
        _waterMeta,
        water.isAcceptableOrUnknown(data['water']!, _waterMeta),
      );
    }
    if (data.containsKey('sewer')) {
      context.handle(
        _sewerMeta,
        sewer.isAcceptableOrUnknown(data['sewer']!, _sewerMeta),
      );
    }
    if (data.containsKey('max_length_ft')) {
      context.handle(
        _maxLengthFtMeta,
        maxLengthFt.isAcceptableOrUnknown(
          data['max_length_ft']!,
          _maxLengthFtMeta,
        ),
      );
    }
    if (data.containsKey('cell_bars')) {
      context.handle(
        _cellBarsMeta,
        cellBars.isAcceptableOrUnknown(data['cell_bars']!, _cellBarsMeta),
      );
    }
    if (data.containsKey('cell_carrier')) {
      context.handle(
        _cellCarrierMeta,
        cellCarrier.isAcceptableOrUnknown(
          data['cell_carrier']!,
          _cellCarrierMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Site map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Site(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      campgroundId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}campground_id'],
      )!,
      siteNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site_no'],
      )!,
      amps: $SitesTable.$converteramps.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}amps'],
        )!,
      ),
      water: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}water'],
      )!,
      sewer: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sewer'],
      )!,
      maxLengthFt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_length_ft'],
      ),
      approach: $SitesTable.$converterapproachn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}approach'],
        ),
      ),
      shade: $SitesTable.$convertershaden.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}shade'],
        ),
      ),
      level: $SitesTable.$converterleveln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}level'],
        ),
      ),
      cellBars: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cell_bars'],
      ),
      cellCarrier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cell_carrier'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $SitesTable createAlias(String alias) {
    return $SitesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Amps, String, String> $converteramps =
      const EnumNameConverter<Amps>(Amps.values);
  static JsonTypeConverter2<Approach, String, String> $converterapproach =
      const EnumNameConverter<Approach>(Approach.values);
  static JsonTypeConverter2<Approach?, String?, String?> $converterapproachn =
      JsonTypeConverter2.asNullable($converterapproach);
  static JsonTypeConverter2<Shade, String, String> $convertershade =
      const EnumNameConverter<Shade>(Shade.values);
  static JsonTypeConverter2<Shade?, String?, String?> $convertershaden =
      JsonTypeConverter2.asNullable($convertershade);
  static JsonTypeConverter2<Level, String, String> $converterlevel =
      const EnumNameConverter<Level>(Level.values);
  static JsonTypeConverter2<Level?, String?, String?> $converterleveln =
      JsonTypeConverter2.asNullable($converterlevel);
}

class Site extends DataClass implements Insertable<Site> {
  final int id;
  final int campgroundId;
  final String siteNo;
  final Amps amps;
  final bool water;
  final bool sewer;
  final int? maxLengthFt;
  final Approach? approach;
  final Shade? shade;
  final Level? level;
  final int? cellBars;
  final String? cellCarrier;
  final String? notes;
  const Site({
    required this.id,
    required this.campgroundId,
    required this.siteNo,
    required this.amps,
    required this.water,
    required this.sewer,
    this.maxLengthFt,
    this.approach,
    this.shade,
    this.level,
    this.cellBars,
    this.cellCarrier,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['campground_id'] = Variable<int>(campgroundId);
    map['site_no'] = Variable<String>(siteNo);
    {
      map['amps'] = Variable<String>($SitesTable.$converteramps.toSql(amps));
    }
    map['water'] = Variable<bool>(water);
    map['sewer'] = Variable<bool>(sewer);
    if (!nullToAbsent || maxLengthFt != null) {
      map['max_length_ft'] = Variable<int>(maxLengthFt);
    }
    if (!nullToAbsent || approach != null) {
      map['approach'] = Variable<String>(
        $SitesTable.$converterapproachn.toSql(approach),
      );
    }
    if (!nullToAbsent || shade != null) {
      map['shade'] = Variable<String>(
        $SitesTable.$convertershaden.toSql(shade),
      );
    }
    if (!nullToAbsent || level != null) {
      map['level'] = Variable<String>(
        $SitesTable.$converterleveln.toSql(level),
      );
    }
    if (!nullToAbsent || cellBars != null) {
      map['cell_bars'] = Variable<int>(cellBars);
    }
    if (!nullToAbsent || cellCarrier != null) {
      map['cell_carrier'] = Variable<String>(cellCarrier);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  SitesCompanion toCompanion(bool nullToAbsent) {
    return SitesCompanion(
      id: Value(id),
      campgroundId: Value(campgroundId),
      siteNo: Value(siteNo),
      amps: Value(amps),
      water: Value(water),
      sewer: Value(sewer),
      maxLengthFt: maxLengthFt == null && nullToAbsent
          ? const Value.absent()
          : Value(maxLengthFt),
      approach: approach == null && nullToAbsent
          ? const Value.absent()
          : Value(approach),
      shade: shade == null && nullToAbsent
          ? const Value.absent()
          : Value(shade),
      level: level == null && nullToAbsent
          ? const Value.absent()
          : Value(level),
      cellBars: cellBars == null && nullToAbsent
          ? const Value.absent()
          : Value(cellBars),
      cellCarrier: cellCarrier == null && nullToAbsent
          ? const Value.absent()
          : Value(cellCarrier),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Site.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Site(
      id: serializer.fromJson<int>(json['id']),
      campgroundId: serializer.fromJson<int>(json['campgroundId']),
      siteNo: serializer.fromJson<String>(json['siteNo']),
      amps: $SitesTable.$converteramps.fromJson(
        serializer.fromJson<String>(json['amps']),
      ),
      water: serializer.fromJson<bool>(json['water']),
      sewer: serializer.fromJson<bool>(json['sewer']),
      maxLengthFt: serializer.fromJson<int?>(json['maxLengthFt']),
      approach: $SitesTable.$converterapproachn.fromJson(
        serializer.fromJson<String?>(json['approach']),
      ),
      shade: $SitesTable.$convertershaden.fromJson(
        serializer.fromJson<String?>(json['shade']),
      ),
      level: $SitesTable.$converterleveln.fromJson(
        serializer.fromJson<String?>(json['level']),
      ),
      cellBars: serializer.fromJson<int?>(json['cellBars']),
      cellCarrier: serializer.fromJson<String?>(json['cellCarrier']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'campgroundId': serializer.toJson<int>(campgroundId),
      'siteNo': serializer.toJson<String>(siteNo),
      'amps': serializer.toJson<String>(
        $SitesTable.$converteramps.toJson(amps),
      ),
      'water': serializer.toJson<bool>(water),
      'sewer': serializer.toJson<bool>(sewer),
      'maxLengthFt': serializer.toJson<int?>(maxLengthFt),
      'approach': serializer.toJson<String?>(
        $SitesTable.$converterapproachn.toJson(approach),
      ),
      'shade': serializer.toJson<String?>(
        $SitesTable.$convertershaden.toJson(shade),
      ),
      'level': serializer.toJson<String?>(
        $SitesTable.$converterleveln.toJson(level),
      ),
      'cellBars': serializer.toJson<int?>(cellBars),
      'cellCarrier': serializer.toJson<String?>(cellCarrier),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Site copyWith({
    int? id,
    int? campgroundId,
    String? siteNo,
    Amps? amps,
    bool? water,
    bool? sewer,
    Value<int?> maxLengthFt = const Value.absent(),
    Value<Approach?> approach = const Value.absent(),
    Value<Shade?> shade = const Value.absent(),
    Value<Level?> level = const Value.absent(),
    Value<int?> cellBars = const Value.absent(),
    Value<String?> cellCarrier = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Site(
    id: id ?? this.id,
    campgroundId: campgroundId ?? this.campgroundId,
    siteNo: siteNo ?? this.siteNo,
    amps: amps ?? this.amps,
    water: water ?? this.water,
    sewer: sewer ?? this.sewer,
    maxLengthFt: maxLengthFt.present ? maxLengthFt.value : this.maxLengthFt,
    approach: approach.present ? approach.value : this.approach,
    shade: shade.present ? shade.value : this.shade,
    level: level.present ? level.value : this.level,
    cellBars: cellBars.present ? cellBars.value : this.cellBars,
    cellCarrier: cellCarrier.present ? cellCarrier.value : this.cellCarrier,
    notes: notes.present ? notes.value : this.notes,
  );
  Site copyWithCompanion(SitesCompanion data) {
    return Site(
      id: data.id.present ? data.id.value : this.id,
      campgroundId: data.campgroundId.present
          ? data.campgroundId.value
          : this.campgroundId,
      siteNo: data.siteNo.present ? data.siteNo.value : this.siteNo,
      amps: data.amps.present ? data.amps.value : this.amps,
      water: data.water.present ? data.water.value : this.water,
      sewer: data.sewer.present ? data.sewer.value : this.sewer,
      maxLengthFt: data.maxLengthFt.present
          ? data.maxLengthFt.value
          : this.maxLengthFt,
      approach: data.approach.present ? data.approach.value : this.approach,
      shade: data.shade.present ? data.shade.value : this.shade,
      level: data.level.present ? data.level.value : this.level,
      cellBars: data.cellBars.present ? data.cellBars.value : this.cellBars,
      cellCarrier: data.cellCarrier.present
          ? data.cellCarrier.value
          : this.cellCarrier,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Site(')
          ..write('id: $id, ')
          ..write('campgroundId: $campgroundId, ')
          ..write('siteNo: $siteNo, ')
          ..write('amps: $amps, ')
          ..write('water: $water, ')
          ..write('sewer: $sewer, ')
          ..write('maxLengthFt: $maxLengthFt, ')
          ..write('approach: $approach, ')
          ..write('shade: $shade, ')
          ..write('level: $level, ')
          ..write('cellBars: $cellBars, ')
          ..write('cellCarrier: $cellCarrier, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    campgroundId,
    siteNo,
    amps,
    water,
    sewer,
    maxLengthFt,
    approach,
    shade,
    level,
    cellBars,
    cellCarrier,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Site &&
          other.id == this.id &&
          other.campgroundId == this.campgroundId &&
          other.siteNo == this.siteNo &&
          other.amps == this.amps &&
          other.water == this.water &&
          other.sewer == this.sewer &&
          other.maxLengthFt == this.maxLengthFt &&
          other.approach == this.approach &&
          other.shade == this.shade &&
          other.level == this.level &&
          other.cellBars == this.cellBars &&
          other.cellCarrier == this.cellCarrier &&
          other.notes == this.notes);
}

class SitesCompanion extends UpdateCompanion<Site> {
  final Value<int> id;
  final Value<int> campgroundId;
  final Value<String> siteNo;
  final Value<Amps> amps;
  final Value<bool> water;
  final Value<bool> sewer;
  final Value<int?> maxLengthFt;
  final Value<Approach?> approach;
  final Value<Shade?> shade;
  final Value<Level?> level;
  final Value<int?> cellBars;
  final Value<String?> cellCarrier;
  final Value<String?> notes;
  const SitesCompanion({
    this.id = const Value.absent(),
    this.campgroundId = const Value.absent(),
    this.siteNo = const Value.absent(),
    this.amps = const Value.absent(),
    this.water = const Value.absent(),
    this.sewer = const Value.absent(),
    this.maxLengthFt = const Value.absent(),
    this.approach = const Value.absent(),
    this.shade = const Value.absent(),
    this.level = const Value.absent(),
    this.cellBars = const Value.absent(),
    this.cellCarrier = const Value.absent(),
    this.notes = const Value.absent(),
  });
  SitesCompanion.insert({
    this.id = const Value.absent(),
    required int campgroundId,
    required String siteNo,
    required Amps amps,
    this.water = const Value.absent(),
    this.sewer = const Value.absent(),
    this.maxLengthFt = const Value.absent(),
    this.approach = const Value.absent(),
    this.shade = const Value.absent(),
    this.level = const Value.absent(),
    this.cellBars = const Value.absent(),
    this.cellCarrier = const Value.absent(),
    this.notes = const Value.absent(),
  }) : campgroundId = Value(campgroundId),
       siteNo = Value(siteNo),
       amps = Value(amps);
  static Insertable<Site> custom({
    Expression<int>? id,
    Expression<int>? campgroundId,
    Expression<String>? siteNo,
    Expression<String>? amps,
    Expression<bool>? water,
    Expression<bool>? sewer,
    Expression<int>? maxLengthFt,
    Expression<String>? approach,
    Expression<String>? shade,
    Expression<String>? level,
    Expression<int>? cellBars,
    Expression<String>? cellCarrier,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (campgroundId != null) 'campground_id': campgroundId,
      if (siteNo != null) 'site_no': siteNo,
      if (amps != null) 'amps': amps,
      if (water != null) 'water': water,
      if (sewer != null) 'sewer': sewer,
      if (maxLengthFt != null) 'max_length_ft': maxLengthFt,
      if (approach != null) 'approach': approach,
      if (shade != null) 'shade': shade,
      if (level != null) 'level': level,
      if (cellBars != null) 'cell_bars': cellBars,
      if (cellCarrier != null) 'cell_carrier': cellCarrier,
      if (notes != null) 'notes': notes,
    });
  }

  SitesCompanion copyWith({
    Value<int>? id,
    Value<int>? campgroundId,
    Value<String>? siteNo,
    Value<Amps>? amps,
    Value<bool>? water,
    Value<bool>? sewer,
    Value<int?>? maxLengthFt,
    Value<Approach?>? approach,
    Value<Shade?>? shade,
    Value<Level?>? level,
    Value<int?>? cellBars,
    Value<String?>? cellCarrier,
    Value<String?>? notes,
  }) {
    return SitesCompanion(
      id: id ?? this.id,
      campgroundId: campgroundId ?? this.campgroundId,
      siteNo: siteNo ?? this.siteNo,
      amps: amps ?? this.amps,
      water: water ?? this.water,
      sewer: sewer ?? this.sewer,
      maxLengthFt: maxLengthFt ?? this.maxLengthFt,
      approach: approach ?? this.approach,
      shade: shade ?? this.shade,
      level: level ?? this.level,
      cellBars: cellBars ?? this.cellBars,
      cellCarrier: cellCarrier ?? this.cellCarrier,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (campgroundId.present) {
      map['campground_id'] = Variable<int>(campgroundId.value);
    }
    if (siteNo.present) {
      map['site_no'] = Variable<String>(siteNo.value);
    }
    if (amps.present) {
      map['amps'] = Variable<String>(
        $SitesTable.$converteramps.toSql(amps.value),
      );
    }
    if (water.present) {
      map['water'] = Variable<bool>(water.value);
    }
    if (sewer.present) {
      map['sewer'] = Variable<bool>(sewer.value);
    }
    if (maxLengthFt.present) {
      map['max_length_ft'] = Variable<int>(maxLengthFt.value);
    }
    if (approach.present) {
      map['approach'] = Variable<String>(
        $SitesTable.$converterapproachn.toSql(approach.value),
      );
    }
    if (shade.present) {
      map['shade'] = Variable<String>(
        $SitesTable.$convertershaden.toSql(shade.value),
      );
    }
    if (level.present) {
      map['level'] = Variable<String>(
        $SitesTable.$converterleveln.toSql(level.value),
      );
    }
    if (cellBars.present) {
      map['cell_bars'] = Variable<int>(cellBars.value);
    }
    if (cellCarrier.present) {
      map['cell_carrier'] = Variable<String>(cellCarrier.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SitesCompanion(')
          ..write('id: $id, ')
          ..write('campgroundId: $campgroundId, ')
          ..write('siteNo: $siteNo, ')
          ..write('amps: $amps, ')
          ..write('water: $water, ')
          ..write('sewer: $sewer, ')
          ..write('maxLengthFt: $maxLengthFt, ')
          ..write('approach: $approach, ')
          ..write('shade: $shade, ')
          ..write('level: $level, ')
          ..write('cellBars: $cellBars, ')
          ..write('cellCarrier: $cellCarrier, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $AppJournalEntriesTable extends AppJournalEntries
    with TableInfo<$AppJournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppJournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    check: () => ComparableExpr(rating).isBetweenValues(1, 5),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, notes, rating, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AppJournalEntriesTable createAlias(String alias) {
    return $AppJournalEntriesTable(attachedDatabase, alias);
  }
}

class AppJournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<int> id;
  final Value<String?> notes;
  final Value<int?> rating;
  final Value<DateTime> createdAt;
  const AppJournalEntriesCompanion({
    this.id = const Value.absent(),
    this.notes = const Value.absent(),
    this.rating = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AppJournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.notes = const Value.absent(),
    this.rating = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<JournalEntry> custom({
    Expression<int>? id,
    Expression<String>? notes,
    Expression<int>? rating,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notes != null) 'notes': notes,
      if (rating != null) 'rating': rating,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AppJournalEntriesCompanion copyWith({
    Value<int>? id,
    Value<String?>? notes,
    Value<int?>? rating,
    Value<DateTime>? createdAt,
  }) {
    return AppJournalEntriesCompanion(
      id: id ?? this.id,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppJournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('notes: $notes, ')
          ..write('rating: $rating, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $VisitsTable extends Visits with TableInfo<$VisitsTable, Visit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
    'site_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sites (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _arriveMeta = const VerificationMeta('arrive');
  @override
  late final GeneratedColumn<DateTime> arrive = GeneratedColumn<DateTime>(
    'arrive',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departMeta = const VerificationMeta('depart');
  @override
  late final GeneratedColumn<DateTime> depart = GeneratedColumn<DateTime>(
    'depart',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costTotalCentsMeta = const VerificationMeta(
    'costTotalCents',
  );
  @override
  late final GeneratedColumn<int> costTotalCents = GeneratedColumn<int>(
    'cost_total_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _journalEntryIdMeta = const VerificationMeta(
    'journalEntryId',
  );
  @override
  late final GeneratedColumn<int> journalEntryId = GeneratedColumn<int>(
    'journal_entry_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    siteId,
    arrive,
    depart,
    costTotalCents,
    journalEntryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Visit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('arrive')) {
      context.handle(
        _arriveMeta,
        arrive.isAcceptableOrUnknown(data['arrive']!, _arriveMeta),
      );
    } else if (isInserting) {
      context.missing(_arriveMeta);
    }
    if (data.containsKey('depart')) {
      context.handle(
        _departMeta,
        depart.isAcceptableOrUnknown(data['depart']!, _departMeta),
      );
    } else if (isInserting) {
      context.missing(_departMeta);
    }
    if (data.containsKey('cost_total_cents')) {
      context.handle(
        _costTotalCentsMeta,
        costTotalCents.isAcceptableOrUnknown(
          data['cost_total_cents']!,
          _costTotalCentsMeta,
        ),
      );
    }
    if (data.containsKey('journal_entry_id')) {
      context.handle(
        _journalEntryIdMeta,
        journalEntryId.isAcceptableOrUnknown(
          data['journal_entry_id']!,
          _journalEntryIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Visit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Visit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}site_id'],
      )!,
      arrive: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}arrive'],
      )!,
      depart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}depart'],
      )!,
      costTotalCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_total_cents'],
      ),
      journalEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}journal_entry_id'],
      ),
    );
  }

  @override
  $VisitsTable createAlias(String alias) {
    return $VisitsTable(attachedDatabase, alias);
  }
}

class Visit extends DataClass implements Insertable<Visit> {
  final int id;
  final int siteId;
  final DateTime arrive;
  final DateTime depart;
  final int? costTotalCents;
  final int? journalEntryId;
  const Visit({
    required this.id,
    required this.siteId,
    required this.arrive,
    required this.depart,
    this.costTotalCents,
    this.journalEntryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['site_id'] = Variable<int>(siteId);
    map['arrive'] = Variable<DateTime>(arrive);
    map['depart'] = Variable<DateTime>(depart);
    if (!nullToAbsent || costTotalCents != null) {
      map['cost_total_cents'] = Variable<int>(costTotalCents);
    }
    if (!nullToAbsent || journalEntryId != null) {
      map['journal_entry_id'] = Variable<int>(journalEntryId);
    }
    return map;
  }

  VisitsCompanion toCompanion(bool nullToAbsent) {
    return VisitsCompanion(
      id: Value(id),
      siteId: Value(siteId),
      arrive: Value(arrive),
      depart: Value(depart),
      costTotalCents: costTotalCents == null && nullToAbsent
          ? const Value.absent()
          : Value(costTotalCents),
      journalEntryId: journalEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(journalEntryId),
    );
  }

  factory Visit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Visit(
      id: serializer.fromJson<int>(json['id']),
      siteId: serializer.fromJson<int>(json['siteId']),
      arrive: serializer.fromJson<DateTime>(json['arrive']),
      depart: serializer.fromJson<DateTime>(json['depart']),
      costTotalCents: serializer.fromJson<int?>(json['costTotalCents']),
      journalEntryId: serializer.fromJson<int?>(json['journalEntryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'siteId': serializer.toJson<int>(siteId),
      'arrive': serializer.toJson<DateTime>(arrive),
      'depart': serializer.toJson<DateTime>(depart),
      'costTotalCents': serializer.toJson<int?>(costTotalCents),
      'journalEntryId': serializer.toJson<int?>(journalEntryId),
    };
  }

  Visit copyWith({
    int? id,
    int? siteId,
    DateTime? arrive,
    DateTime? depart,
    Value<int?> costTotalCents = const Value.absent(),
    Value<int?> journalEntryId = const Value.absent(),
  }) => Visit(
    id: id ?? this.id,
    siteId: siteId ?? this.siteId,
    arrive: arrive ?? this.arrive,
    depart: depart ?? this.depart,
    costTotalCents: costTotalCents.present
        ? costTotalCents.value
        : this.costTotalCents,
    journalEntryId: journalEntryId.present
        ? journalEntryId.value
        : this.journalEntryId,
  );
  Visit copyWithCompanion(VisitsCompanion data) {
    return Visit(
      id: data.id.present ? data.id.value : this.id,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      arrive: data.arrive.present ? data.arrive.value : this.arrive,
      depart: data.depart.present ? data.depart.value : this.depart,
      costTotalCents: data.costTotalCents.present
          ? data.costTotalCents.value
          : this.costTotalCents,
      journalEntryId: data.journalEntryId.present
          ? data.journalEntryId.value
          : this.journalEntryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Visit(')
          ..write('id: $id, ')
          ..write('siteId: $siteId, ')
          ..write('arrive: $arrive, ')
          ..write('depart: $depart, ')
          ..write('costTotalCents: $costTotalCents, ')
          ..write('journalEntryId: $journalEntryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, siteId, arrive, depart, costTotalCents, journalEntryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Visit &&
          other.id == this.id &&
          other.siteId == this.siteId &&
          other.arrive == this.arrive &&
          other.depart == this.depart &&
          other.costTotalCents == this.costTotalCents &&
          other.journalEntryId == this.journalEntryId);
}

class VisitsCompanion extends UpdateCompanion<Visit> {
  final Value<int> id;
  final Value<int> siteId;
  final Value<DateTime> arrive;
  final Value<DateTime> depart;
  final Value<int?> costTotalCents;
  final Value<int?> journalEntryId;
  const VisitsCompanion({
    this.id = const Value.absent(),
    this.siteId = const Value.absent(),
    this.arrive = const Value.absent(),
    this.depart = const Value.absent(),
    this.costTotalCents = const Value.absent(),
    this.journalEntryId = const Value.absent(),
  });
  VisitsCompanion.insert({
    this.id = const Value.absent(),
    required int siteId,
    required DateTime arrive,
    required DateTime depart,
    this.costTotalCents = const Value.absent(),
    this.journalEntryId = const Value.absent(),
  }) : siteId = Value(siteId),
       arrive = Value(arrive),
       depart = Value(depart);
  static Insertable<Visit> custom({
    Expression<int>? id,
    Expression<int>? siteId,
    Expression<DateTime>? arrive,
    Expression<DateTime>? depart,
    Expression<int>? costTotalCents,
    Expression<int>? journalEntryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (siteId != null) 'site_id': siteId,
      if (arrive != null) 'arrive': arrive,
      if (depart != null) 'depart': depart,
      if (costTotalCents != null) 'cost_total_cents': costTotalCents,
      if (journalEntryId != null) 'journal_entry_id': journalEntryId,
    });
  }

  VisitsCompanion copyWith({
    Value<int>? id,
    Value<int>? siteId,
    Value<DateTime>? arrive,
    Value<DateTime>? depart,
    Value<int?>? costTotalCents,
    Value<int?>? journalEntryId,
  }) {
    return VisitsCompanion(
      id: id ?? this.id,
      siteId: siteId ?? this.siteId,
      arrive: arrive ?? this.arrive,
      depart: depart ?? this.depart,
      costTotalCents: costTotalCents ?? this.costTotalCents,
      journalEntryId: journalEntryId ?? this.journalEntryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
    }
    if (arrive.present) {
      map['arrive'] = Variable<DateTime>(arrive.value);
    }
    if (depart.present) {
      map['depart'] = Variable<DateTime>(depart.value);
    }
    if (costTotalCents.present) {
      map['cost_total_cents'] = Variable<int>(costTotalCents.value);
    }
    if (journalEntryId.present) {
      map['journal_entry_id'] = Variable<int>(journalEntryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisitsCompanion(')
          ..write('id: $id, ')
          ..write('siteId: $siteId, ')
          ..write('arrive: $arrive, ')
          ..write('depart: $depart, ')
          ..write('costTotalCents: $costTotalCents, ')
          ..write('journalEntryId: $journalEntryId')
          ..write(')'))
        .toString();
  }
}

class $RigsTable extends Rigs with TableInfo<$RigsTable, Rig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RigKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RigKind>($RigsTable.$converterkind);
  static const VerificationMeta _lengthFtMeta = const VerificationMeta(
    'lengthFt',
  );
  @override
  late final GeneratedColumn<int> lengthFt = GeneratedColumn<int>(
    'length_ft',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gvwrLbsMeta = const VerificationMeta(
    'gvwrLbs',
  );
  @override
  late final GeneratedColumn<int> gvwrLbs = GeneratedColumn<int>(
    'gvwr_lbs',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ballSizeInMeta = const VerificationMeta(
    'ballSizeIn',
  );
  @override
  late final GeneratedColumn<String> ballSizeIn = GeneratedColumn<String>(
    'ball_size_in',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hitchDropInMeta = const VerificationMeta(
    'hitchDropIn',
  );
  @override
  late final GeneratedColumn<int> hitchDropIn = GeneratedColumn<int>(
    'hitch_drop_in',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wdBarSettingMeta = const VerificationMeta(
    'wdBarSetting',
  );
  @override
  late final GeneratedColumn<String> wdBarSetting = GeneratedColumn<String>(
    'wd_bar_setting',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tirePsiFrontMeta = const VerificationMeta(
    'tirePsiFront',
  );
  @override
  late final GeneratedColumn<int> tirePsiFront = GeneratedColumn<int>(
    'tire_psi_front',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tirePsiRearMeta = const VerificationMeta(
    'tirePsiRear',
  );
  @override
  late final GeneratedColumn<int> tirePsiRear = GeneratedColumn<int>(
    'tire_psi_rear',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brakeGainMeta = const VerificationMeta(
    'brakeGain',
  );
  @override
  late final GeneratedColumn<int> brakeGain = GeneratedColumn<int>(
    'brake_gain',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bearingServiceDateMeta =
      const VerificationMeta('bearingServiceDate');
  @override
  late final GeneratedColumn<DateTime> bearingServiceDate =
      GeneratedColumn<DateTime>(
        'bearing_service_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _tireDateMeta = const VerificationMeta(
    'tireDate',
  );
  @override
  late final GeneratedColumn<DateTime> tireDate = GeneratedColumn<DateTime>(
    'tire_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _journalEntryIdMeta = const VerificationMeta(
    'journalEntryId',
  );
  @override
  late final GeneratedColumn<int> journalEntryId = GeneratedColumn<int>(
    'journal_entry_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    kind,
    lengthFt,
    gvwrLbs,
    ballSizeIn,
    hitchDropIn,
    wdBarSetting,
    tirePsiFront,
    tirePsiRear,
    brakeGain,
    bearingServiceDate,
    tireDate,
    journalEntryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rigs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Rig> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('length_ft')) {
      context.handle(
        _lengthFtMeta,
        lengthFt.isAcceptableOrUnknown(data['length_ft']!, _lengthFtMeta),
      );
    }
    if (data.containsKey('gvwr_lbs')) {
      context.handle(
        _gvwrLbsMeta,
        gvwrLbs.isAcceptableOrUnknown(data['gvwr_lbs']!, _gvwrLbsMeta),
      );
    }
    if (data.containsKey('ball_size_in')) {
      context.handle(
        _ballSizeInMeta,
        ballSizeIn.isAcceptableOrUnknown(
          data['ball_size_in']!,
          _ballSizeInMeta,
        ),
      );
    }
    if (data.containsKey('hitch_drop_in')) {
      context.handle(
        _hitchDropInMeta,
        hitchDropIn.isAcceptableOrUnknown(
          data['hitch_drop_in']!,
          _hitchDropInMeta,
        ),
      );
    }
    if (data.containsKey('wd_bar_setting')) {
      context.handle(
        _wdBarSettingMeta,
        wdBarSetting.isAcceptableOrUnknown(
          data['wd_bar_setting']!,
          _wdBarSettingMeta,
        ),
      );
    }
    if (data.containsKey('tire_psi_front')) {
      context.handle(
        _tirePsiFrontMeta,
        tirePsiFront.isAcceptableOrUnknown(
          data['tire_psi_front']!,
          _tirePsiFrontMeta,
        ),
      );
    }
    if (data.containsKey('tire_psi_rear')) {
      context.handle(
        _tirePsiRearMeta,
        tirePsiRear.isAcceptableOrUnknown(
          data['tire_psi_rear']!,
          _tirePsiRearMeta,
        ),
      );
    }
    if (data.containsKey('brake_gain')) {
      context.handle(
        _brakeGainMeta,
        brakeGain.isAcceptableOrUnknown(data['brake_gain']!, _brakeGainMeta),
      );
    }
    if (data.containsKey('bearing_service_date')) {
      context.handle(
        _bearingServiceDateMeta,
        bearingServiceDate.isAcceptableOrUnknown(
          data['bearing_service_date']!,
          _bearingServiceDateMeta,
        ),
      );
    }
    if (data.containsKey('tire_date')) {
      context.handle(
        _tireDateMeta,
        tireDate.isAcceptableOrUnknown(data['tire_date']!, _tireDateMeta),
      );
    }
    if (data.containsKey('journal_entry_id')) {
      context.handle(
        _journalEntryIdMeta,
        journalEntryId.isAcceptableOrUnknown(
          data['journal_entry_id']!,
          _journalEntryIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Rig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rig(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $RigsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      lengthFt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}length_ft'],
      ),
      gvwrLbs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gvwr_lbs'],
      ),
      ballSizeIn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ball_size_in'],
      ),
      hitchDropIn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hitch_drop_in'],
      ),
      wdBarSetting: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wd_bar_setting'],
      ),
      tirePsiFront: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tire_psi_front'],
      ),
      tirePsiRear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tire_psi_rear'],
      ),
      brakeGain: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brake_gain'],
      ),
      bearingServiceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}bearing_service_date'],
      ),
      tireDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tire_date'],
      ),
      journalEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}journal_entry_id'],
      ),
    );
  }

  @override
  $RigsTable createAlias(String alias) {
    return $RigsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RigKind, String, String> $converterkind =
      const EnumNameConverter<RigKind>(RigKind.values);
}

class Rig extends DataClass implements Insertable<Rig> {
  final int id;
  final String name;
  final RigKind kind;
  final int? lengthFt;
  final int? gvwrLbs;
  final String? ballSizeIn;
  final int? hitchDropIn;
  final String? wdBarSetting;
  final int? tirePsiFront;
  final int? tirePsiRear;
  final int? brakeGain;
  final DateTime? bearingServiceDate;
  final DateTime? tireDate;
  final int? journalEntryId;
  const Rig({
    required this.id,
    required this.name,
    required this.kind,
    this.lengthFt,
    this.gvwrLbs,
    this.ballSizeIn,
    this.hitchDropIn,
    this.wdBarSetting,
    this.tirePsiFront,
    this.tirePsiRear,
    this.brakeGain,
    this.bearingServiceDate,
    this.tireDate,
    this.journalEntryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<String>($RigsTable.$converterkind.toSql(kind));
    }
    if (!nullToAbsent || lengthFt != null) {
      map['length_ft'] = Variable<int>(lengthFt);
    }
    if (!nullToAbsent || gvwrLbs != null) {
      map['gvwr_lbs'] = Variable<int>(gvwrLbs);
    }
    if (!nullToAbsent || ballSizeIn != null) {
      map['ball_size_in'] = Variable<String>(ballSizeIn);
    }
    if (!nullToAbsent || hitchDropIn != null) {
      map['hitch_drop_in'] = Variable<int>(hitchDropIn);
    }
    if (!nullToAbsent || wdBarSetting != null) {
      map['wd_bar_setting'] = Variable<String>(wdBarSetting);
    }
    if (!nullToAbsent || tirePsiFront != null) {
      map['tire_psi_front'] = Variable<int>(tirePsiFront);
    }
    if (!nullToAbsent || tirePsiRear != null) {
      map['tire_psi_rear'] = Variable<int>(tirePsiRear);
    }
    if (!nullToAbsent || brakeGain != null) {
      map['brake_gain'] = Variable<int>(brakeGain);
    }
    if (!nullToAbsent || bearingServiceDate != null) {
      map['bearing_service_date'] = Variable<DateTime>(bearingServiceDate);
    }
    if (!nullToAbsent || tireDate != null) {
      map['tire_date'] = Variable<DateTime>(tireDate);
    }
    if (!nullToAbsent || journalEntryId != null) {
      map['journal_entry_id'] = Variable<int>(journalEntryId);
    }
    return map;
  }

  RigsCompanion toCompanion(bool nullToAbsent) {
    return RigsCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      lengthFt: lengthFt == null && nullToAbsent
          ? const Value.absent()
          : Value(lengthFt),
      gvwrLbs: gvwrLbs == null && nullToAbsent
          ? const Value.absent()
          : Value(gvwrLbs),
      ballSizeIn: ballSizeIn == null && nullToAbsent
          ? const Value.absent()
          : Value(ballSizeIn),
      hitchDropIn: hitchDropIn == null && nullToAbsent
          ? const Value.absent()
          : Value(hitchDropIn),
      wdBarSetting: wdBarSetting == null && nullToAbsent
          ? const Value.absent()
          : Value(wdBarSetting),
      tirePsiFront: tirePsiFront == null && nullToAbsent
          ? const Value.absent()
          : Value(tirePsiFront),
      tirePsiRear: tirePsiRear == null && nullToAbsent
          ? const Value.absent()
          : Value(tirePsiRear),
      brakeGain: brakeGain == null && nullToAbsent
          ? const Value.absent()
          : Value(brakeGain),
      bearingServiceDate: bearingServiceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(bearingServiceDate),
      tireDate: tireDate == null && nullToAbsent
          ? const Value.absent()
          : Value(tireDate),
      journalEntryId: journalEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(journalEntryId),
    );
  }

  factory Rig.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rig(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: $RigsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      lengthFt: serializer.fromJson<int?>(json['lengthFt']),
      gvwrLbs: serializer.fromJson<int?>(json['gvwrLbs']),
      ballSizeIn: serializer.fromJson<String?>(json['ballSizeIn']),
      hitchDropIn: serializer.fromJson<int?>(json['hitchDropIn']),
      wdBarSetting: serializer.fromJson<String?>(json['wdBarSetting']),
      tirePsiFront: serializer.fromJson<int?>(json['tirePsiFront']),
      tirePsiRear: serializer.fromJson<int?>(json['tirePsiRear']),
      brakeGain: serializer.fromJson<int?>(json['brakeGain']),
      bearingServiceDate: serializer.fromJson<DateTime?>(
        json['bearingServiceDate'],
      ),
      tireDate: serializer.fromJson<DateTime?>(json['tireDate']),
      journalEntryId: serializer.fromJson<int?>(json['journalEntryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>($RigsTable.$converterkind.toJson(kind)),
      'lengthFt': serializer.toJson<int?>(lengthFt),
      'gvwrLbs': serializer.toJson<int?>(gvwrLbs),
      'ballSizeIn': serializer.toJson<String?>(ballSizeIn),
      'hitchDropIn': serializer.toJson<int?>(hitchDropIn),
      'wdBarSetting': serializer.toJson<String?>(wdBarSetting),
      'tirePsiFront': serializer.toJson<int?>(tirePsiFront),
      'tirePsiRear': serializer.toJson<int?>(tirePsiRear),
      'brakeGain': serializer.toJson<int?>(brakeGain),
      'bearingServiceDate': serializer.toJson<DateTime?>(bearingServiceDate),
      'tireDate': serializer.toJson<DateTime?>(tireDate),
      'journalEntryId': serializer.toJson<int?>(journalEntryId),
    };
  }

  Rig copyWith({
    int? id,
    String? name,
    RigKind? kind,
    Value<int?> lengthFt = const Value.absent(),
    Value<int?> gvwrLbs = const Value.absent(),
    Value<String?> ballSizeIn = const Value.absent(),
    Value<int?> hitchDropIn = const Value.absent(),
    Value<String?> wdBarSetting = const Value.absent(),
    Value<int?> tirePsiFront = const Value.absent(),
    Value<int?> tirePsiRear = const Value.absent(),
    Value<int?> brakeGain = const Value.absent(),
    Value<DateTime?> bearingServiceDate = const Value.absent(),
    Value<DateTime?> tireDate = const Value.absent(),
    Value<int?> journalEntryId = const Value.absent(),
  }) => Rig(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    lengthFt: lengthFt.present ? lengthFt.value : this.lengthFt,
    gvwrLbs: gvwrLbs.present ? gvwrLbs.value : this.gvwrLbs,
    ballSizeIn: ballSizeIn.present ? ballSizeIn.value : this.ballSizeIn,
    hitchDropIn: hitchDropIn.present ? hitchDropIn.value : this.hitchDropIn,
    wdBarSetting: wdBarSetting.present ? wdBarSetting.value : this.wdBarSetting,
    tirePsiFront: tirePsiFront.present ? tirePsiFront.value : this.tirePsiFront,
    tirePsiRear: tirePsiRear.present ? tirePsiRear.value : this.tirePsiRear,
    brakeGain: brakeGain.present ? brakeGain.value : this.brakeGain,
    bearingServiceDate: bearingServiceDate.present
        ? bearingServiceDate.value
        : this.bearingServiceDate,
    tireDate: tireDate.present ? tireDate.value : this.tireDate,
    journalEntryId: journalEntryId.present
        ? journalEntryId.value
        : this.journalEntryId,
  );
  Rig copyWithCompanion(RigsCompanion data) {
    return Rig(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      lengthFt: data.lengthFt.present ? data.lengthFt.value : this.lengthFt,
      gvwrLbs: data.gvwrLbs.present ? data.gvwrLbs.value : this.gvwrLbs,
      ballSizeIn: data.ballSizeIn.present
          ? data.ballSizeIn.value
          : this.ballSizeIn,
      hitchDropIn: data.hitchDropIn.present
          ? data.hitchDropIn.value
          : this.hitchDropIn,
      wdBarSetting: data.wdBarSetting.present
          ? data.wdBarSetting.value
          : this.wdBarSetting,
      tirePsiFront: data.tirePsiFront.present
          ? data.tirePsiFront.value
          : this.tirePsiFront,
      tirePsiRear: data.tirePsiRear.present
          ? data.tirePsiRear.value
          : this.tirePsiRear,
      brakeGain: data.brakeGain.present ? data.brakeGain.value : this.brakeGain,
      bearingServiceDate: data.bearingServiceDate.present
          ? data.bearingServiceDate.value
          : this.bearingServiceDate,
      tireDate: data.tireDate.present ? data.tireDate.value : this.tireDate,
      journalEntryId: data.journalEntryId.present
          ? data.journalEntryId.value
          : this.journalEntryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Rig(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('lengthFt: $lengthFt, ')
          ..write('gvwrLbs: $gvwrLbs, ')
          ..write('ballSizeIn: $ballSizeIn, ')
          ..write('hitchDropIn: $hitchDropIn, ')
          ..write('wdBarSetting: $wdBarSetting, ')
          ..write('tirePsiFront: $tirePsiFront, ')
          ..write('tirePsiRear: $tirePsiRear, ')
          ..write('brakeGain: $brakeGain, ')
          ..write('bearingServiceDate: $bearingServiceDate, ')
          ..write('tireDate: $tireDate, ')
          ..write('journalEntryId: $journalEntryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    kind,
    lengthFt,
    gvwrLbs,
    ballSizeIn,
    hitchDropIn,
    wdBarSetting,
    tirePsiFront,
    tirePsiRear,
    brakeGain,
    bearingServiceDate,
    tireDate,
    journalEntryId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rig &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.lengthFt == this.lengthFt &&
          other.gvwrLbs == this.gvwrLbs &&
          other.ballSizeIn == this.ballSizeIn &&
          other.hitchDropIn == this.hitchDropIn &&
          other.wdBarSetting == this.wdBarSetting &&
          other.tirePsiFront == this.tirePsiFront &&
          other.tirePsiRear == this.tirePsiRear &&
          other.brakeGain == this.brakeGain &&
          other.bearingServiceDate == this.bearingServiceDate &&
          other.tireDate == this.tireDate &&
          other.journalEntryId == this.journalEntryId);
}

class RigsCompanion extends UpdateCompanion<Rig> {
  final Value<int> id;
  final Value<String> name;
  final Value<RigKind> kind;
  final Value<int?> lengthFt;
  final Value<int?> gvwrLbs;
  final Value<String?> ballSizeIn;
  final Value<int?> hitchDropIn;
  final Value<String?> wdBarSetting;
  final Value<int?> tirePsiFront;
  final Value<int?> tirePsiRear;
  final Value<int?> brakeGain;
  final Value<DateTime?> bearingServiceDate;
  final Value<DateTime?> tireDate;
  final Value<int?> journalEntryId;
  const RigsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.lengthFt = const Value.absent(),
    this.gvwrLbs = const Value.absent(),
    this.ballSizeIn = const Value.absent(),
    this.hitchDropIn = const Value.absent(),
    this.wdBarSetting = const Value.absent(),
    this.tirePsiFront = const Value.absent(),
    this.tirePsiRear = const Value.absent(),
    this.brakeGain = const Value.absent(),
    this.bearingServiceDate = const Value.absent(),
    this.tireDate = const Value.absent(),
    this.journalEntryId = const Value.absent(),
  });
  RigsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required RigKind kind,
    this.lengthFt = const Value.absent(),
    this.gvwrLbs = const Value.absent(),
    this.ballSizeIn = const Value.absent(),
    this.hitchDropIn = const Value.absent(),
    this.wdBarSetting = const Value.absent(),
    this.tirePsiFront = const Value.absent(),
    this.tirePsiRear = const Value.absent(),
    this.brakeGain = const Value.absent(),
    this.bearingServiceDate = const Value.absent(),
    this.tireDate = const Value.absent(),
    this.journalEntryId = const Value.absent(),
  }) : name = Value(name),
       kind = Value(kind);
  static Insertable<Rig> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<int>? lengthFt,
    Expression<int>? gvwrLbs,
    Expression<String>? ballSizeIn,
    Expression<int>? hitchDropIn,
    Expression<String>? wdBarSetting,
    Expression<int>? tirePsiFront,
    Expression<int>? tirePsiRear,
    Expression<int>? brakeGain,
    Expression<DateTime>? bearingServiceDate,
    Expression<DateTime>? tireDate,
    Expression<int>? journalEntryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (lengthFt != null) 'length_ft': lengthFt,
      if (gvwrLbs != null) 'gvwr_lbs': gvwrLbs,
      if (ballSizeIn != null) 'ball_size_in': ballSizeIn,
      if (hitchDropIn != null) 'hitch_drop_in': hitchDropIn,
      if (wdBarSetting != null) 'wd_bar_setting': wdBarSetting,
      if (tirePsiFront != null) 'tire_psi_front': tirePsiFront,
      if (tirePsiRear != null) 'tire_psi_rear': tirePsiRear,
      if (brakeGain != null) 'brake_gain': brakeGain,
      if (bearingServiceDate != null)
        'bearing_service_date': bearingServiceDate,
      if (tireDate != null) 'tire_date': tireDate,
      if (journalEntryId != null) 'journal_entry_id': journalEntryId,
    });
  }

  RigsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<RigKind>? kind,
    Value<int?>? lengthFt,
    Value<int?>? gvwrLbs,
    Value<String?>? ballSizeIn,
    Value<int?>? hitchDropIn,
    Value<String?>? wdBarSetting,
    Value<int?>? tirePsiFront,
    Value<int?>? tirePsiRear,
    Value<int?>? brakeGain,
    Value<DateTime?>? bearingServiceDate,
    Value<DateTime?>? tireDate,
    Value<int?>? journalEntryId,
  }) {
    return RigsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      lengthFt: lengthFt ?? this.lengthFt,
      gvwrLbs: gvwrLbs ?? this.gvwrLbs,
      ballSizeIn: ballSizeIn ?? this.ballSizeIn,
      hitchDropIn: hitchDropIn ?? this.hitchDropIn,
      wdBarSetting: wdBarSetting ?? this.wdBarSetting,
      tirePsiFront: tirePsiFront ?? this.tirePsiFront,
      tirePsiRear: tirePsiRear ?? this.tirePsiRear,
      brakeGain: brakeGain ?? this.brakeGain,
      bearingServiceDate: bearingServiceDate ?? this.bearingServiceDate,
      tireDate: tireDate ?? this.tireDate,
      journalEntryId: journalEntryId ?? this.journalEntryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $RigsTable.$converterkind.toSql(kind.value),
      );
    }
    if (lengthFt.present) {
      map['length_ft'] = Variable<int>(lengthFt.value);
    }
    if (gvwrLbs.present) {
      map['gvwr_lbs'] = Variable<int>(gvwrLbs.value);
    }
    if (ballSizeIn.present) {
      map['ball_size_in'] = Variable<String>(ballSizeIn.value);
    }
    if (hitchDropIn.present) {
      map['hitch_drop_in'] = Variable<int>(hitchDropIn.value);
    }
    if (wdBarSetting.present) {
      map['wd_bar_setting'] = Variable<String>(wdBarSetting.value);
    }
    if (tirePsiFront.present) {
      map['tire_psi_front'] = Variable<int>(tirePsiFront.value);
    }
    if (tirePsiRear.present) {
      map['tire_psi_rear'] = Variable<int>(tirePsiRear.value);
    }
    if (brakeGain.present) {
      map['brake_gain'] = Variable<int>(brakeGain.value);
    }
    if (bearingServiceDate.present) {
      map['bearing_service_date'] = Variable<DateTime>(
        bearingServiceDate.value,
      );
    }
    if (tireDate.present) {
      map['tire_date'] = Variable<DateTime>(tireDate.value);
    }
    if (journalEntryId.present) {
      map['journal_entry_id'] = Variable<int>(journalEntryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RigsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('lengthFt: $lengthFt, ')
          ..write('gvwrLbs: $gvwrLbs, ')
          ..write('ballSizeIn: $ballSizeIn, ')
          ..write('hitchDropIn: $hitchDropIn, ')
          ..write('wdBarSetting: $wdBarSetting, ')
          ..write('tirePsiFront: $tirePsiFront, ')
          ..write('tirePsiRear: $tirePsiRear, ')
          ..write('brakeGain: $brakeGain, ')
          ..write('bearingServiceDate: $bearingServiceDate, ')
          ..write('tireDate: $tireDate, ')
          ..write('journalEntryId: $journalEntryId')
          ..write(')'))
        .toString();
  }
}

class $AppJournalPhotosTable extends AppJournalPhotos
    with TableInfo<$AppJournalPhotosTable, JournalPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppJournalPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, entryId, path, caption];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
    );
  }

  @override
  $AppJournalPhotosTable createAlias(String alias) {
    return $AppJournalPhotosTable(attachedDatabase, alias);
  }
}

class AppJournalPhotosCompanion extends UpdateCompanion<JournalPhoto> {
  final Value<int> id;
  final Value<int> entryId;
  final Value<String> path;
  final Value<String?> caption;
  const AppJournalPhotosCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.path = const Value.absent(),
    this.caption = const Value.absent(),
  });
  AppJournalPhotosCompanion.insert({
    this.id = const Value.absent(),
    required int entryId,
    required String path,
    this.caption = const Value.absent(),
  }) : entryId = Value(entryId),
       path = Value(path);
  static Insertable<JournalPhoto> custom({
    Expression<int>? id,
    Expression<int>? entryId,
    Expression<String>? path,
    Expression<String>? caption,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (path != null) 'path': path,
      if (caption != null) 'caption': caption,
    });
  }

  AppJournalPhotosCompanion copyWith({
    Value<int>? id,
    Value<int>? entryId,
    Value<String>? path,
    Value<String?>? caption,
  }) {
    return AppJournalPhotosCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      path: path ?? this.path,
      caption: caption ?? this.caption,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppJournalPhotosCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('path: $path, ')
          ..write('caption: $caption')
          ..write(')'))
        .toString();
  }
}

class $AppJournalTagsTable extends AppJournalTags
    with TableInfo<$AppJournalTagsTable, JournalTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppJournalTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
    'tag',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, entryId, tag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('tag')) {
      context.handle(
        _tagMeta,
        tag.isAcceptableOrUnknown(data['tag']!, _tagMeta),
      );
    } else if (isInserting) {
      context.missing(_tagMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {entryId, tag},
  ];
  @override
  JournalTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalTag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      tag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag'],
      )!,
    );
  }

  @override
  $AppJournalTagsTable createAlias(String alias) {
    return $AppJournalTagsTable(attachedDatabase, alias);
  }
}

class AppJournalTagsCompanion extends UpdateCompanion<JournalTag> {
  final Value<int> id;
  final Value<int> entryId;
  final Value<String> tag;
  const AppJournalTagsCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.tag = const Value.absent(),
  });
  AppJournalTagsCompanion.insert({
    this.id = const Value.absent(),
    required int entryId,
    required String tag,
  }) : entryId = Value(entryId),
       tag = Value(tag);
  static Insertable<JournalTag> custom({
    Expression<int>? id,
    Expression<int>? entryId,
    Expression<String>? tag,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (tag != null) 'tag': tag,
    });
  }

  AppJournalTagsCompanion copyWith({
    Value<int>? id,
    Value<int>? entryId,
    Value<String>? tag,
  }) {
    return AppJournalTagsCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      tag: tag ?? this.tag,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppJournalTagsCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('tag: $tag')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CampgroundsTable campgrounds = $CampgroundsTable(this);
  late final $SitesTable sites = $SitesTable(this);
  late final $AppJournalEntriesTable appJournalEntries =
      $AppJournalEntriesTable(this);
  late final $VisitsTable visits = $VisitsTable(this);
  late final $RigsTable rigs = $RigsTable(this);
  late final $AppJournalPhotosTable appJournalPhotos = $AppJournalPhotosTable(
    this,
  );
  late final $AppJournalTagsTable appJournalTags = $AppJournalTagsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    campgrounds,
    sites,
    appJournalEntries,
    visits,
    rigs,
    appJournalPhotos,
    appJournalTags,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'campgrounds',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sites', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sites',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('visits', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CampgroundsTableCreateCompanionBuilder =
    CampgroundsCompanion Function({
      Value<int> id,
      required String name,
      required CampgroundKind kind,
      Value<String?> state,
      Value<String?> notes,
      Value<int?> rating,
      Value<bool> wouldReturn,
      Value<double?> lat,
      Value<double?> lon,
      Value<DateTime> createdAt,
    });
typedef $$CampgroundsTableUpdateCompanionBuilder =
    CampgroundsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<CampgroundKind> kind,
      Value<String?> state,
      Value<String?> notes,
      Value<int?> rating,
      Value<bool> wouldReturn,
      Value<double?> lat,
      Value<double?> lon,
      Value<DateTime> createdAt,
    });

final class $$CampgroundsTableReferences
    extends BaseReferences<_$AppDatabase, $CampgroundsTable, Campground> {
  $$CampgroundsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SitesTable, List<Site>> _sitesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sites,
    aliasName: 'campgrounds__id__sites__campground_id',
  );

  $$SitesTableProcessedTableManager get sitesRefs {
    final manager = $$SitesTableTableManager(
      $_db,
      $_db.sites,
    ).filter((f) => f.campgroundId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sitesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CampgroundsTableFilterComposer
    extends Composer<_$AppDatabase, $CampgroundsTable> {
  $$CampgroundsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CampgroundKind, CampgroundKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get wouldReturn => $composableBuilder(
    column: $table.wouldReturn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sitesRefs(
    Expression<bool> Function($$SitesTableFilterComposer f) f,
  ) {
    final $$SitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.campgroundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableFilterComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CampgroundsTableOrderingComposer
    extends Composer<_$AppDatabase, $CampgroundsTable> {
  $$CampgroundsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wouldReturn => $composableBuilder(
    column: $table.wouldReturn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CampgroundsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CampgroundsTable> {
  $$CampgroundsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CampgroundKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<bool> get wouldReturn => $composableBuilder(
    column: $table.wouldReturn,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> sitesRefs<T extends Object>(
    Expression<T> Function($$SitesTableAnnotationComposer a) f,
  ) {
    final $$SitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.campgroundId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableAnnotationComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CampgroundsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CampgroundsTable,
          Campground,
          $$CampgroundsTableFilterComposer,
          $$CampgroundsTableOrderingComposer,
          $$CampgroundsTableAnnotationComposer,
          $$CampgroundsTableCreateCompanionBuilder,
          $$CampgroundsTableUpdateCompanionBuilder,
          (Campground, $$CampgroundsTableReferences),
          Campground,
          PrefetchHooks Function({bool sitesRefs})
        > {
  $$CampgroundsTableTableManager(_$AppDatabase db, $CampgroundsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CampgroundsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CampgroundsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CampgroundsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<CampgroundKind> kind = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<bool> wouldReturn = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lon = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CampgroundsCompanion(
                id: id,
                name: name,
                kind: kind,
                state: state,
                notes: notes,
                rating: rating,
                wouldReturn: wouldReturn,
                lat: lat,
                lon: lon,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required CampgroundKind kind,
                Value<String?> state = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<bool> wouldReturn = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lon = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CampgroundsCompanion.insert(
                id: id,
                name: name,
                kind: kind,
                state: state,
                notes: notes,
                rating: rating,
                wouldReturn: wouldReturn,
                lat: lat,
                lon: lon,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CampgroundsTable, Campground>(table),
                  $$CampgroundsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sitesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sitesRefs) db.sites],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sitesRefs)
                    await $_getPrefetchedData<
                      Campground,
                      $CampgroundsTable,
                      Site
                    >(
                      currentTable: table,
                      referencedTable: $$CampgroundsTableReferences
                          ._sitesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CampgroundsTableReferences(db, table, p0).sitesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.campgroundId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CampgroundsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CampgroundsTable,
      Campground,
      $$CampgroundsTableFilterComposer,
      $$CampgroundsTableOrderingComposer,
      $$CampgroundsTableAnnotationComposer,
      $$CampgroundsTableCreateCompanionBuilder,
      $$CampgroundsTableUpdateCompanionBuilder,
      (Campground, $$CampgroundsTableReferences),
      Campground,
      PrefetchHooks Function({bool sitesRefs})
    >;
typedef $$SitesTableCreateCompanionBuilder =
    SitesCompanion Function({
      Value<int> id,
      required int campgroundId,
      required String siteNo,
      required Amps amps,
      Value<bool> water,
      Value<bool> sewer,
      Value<int?> maxLengthFt,
      Value<Approach?> approach,
      Value<Shade?> shade,
      Value<Level?> level,
      Value<int?> cellBars,
      Value<String?> cellCarrier,
      Value<String?> notes,
    });
typedef $$SitesTableUpdateCompanionBuilder =
    SitesCompanion Function({
      Value<int> id,
      Value<int> campgroundId,
      Value<String> siteNo,
      Value<Amps> amps,
      Value<bool> water,
      Value<bool> sewer,
      Value<int?> maxLengthFt,
      Value<Approach?> approach,
      Value<Shade?> shade,
      Value<Level?> level,
      Value<int?> cellBars,
      Value<String?> cellCarrier,
      Value<String?> notes,
    });

final class $$SitesTableReferences
    extends BaseReferences<_$AppDatabase, $SitesTable, Site> {
  $$SitesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CampgroundsTable _campgroundIdTable(_$AppDatabase db) =>
      db.campgrounds.createAlias('sites__campground_id__campgrounds__id');

  $$CampgroundsTableProcessedTableManager get campgroundId {
    final $_column = $_itemColumn<int>('campground_id')!;

    final manager = $$CampgroundsTableTableManager(
      $_db,
      $_db.campgrounds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_campgroundIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$VisitsTable, List<Visit>> _visitsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.visits,
    aliasName: 'sites__id__visits__site_id',
  );

  $$VisitsTableProcessedTableManager get visitsRefs {
    final manager = $$VisitsTableTableManager(
      $_db,
      $_db.visits,
    ).filter((f) => f.siteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_visitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SitesTableFilterComposer extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siteNo => $composableBuilder(
    column: $table.siteNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Amps, Amps, String> get amps =>
      $composableBuilder(
        column: $table.amps,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get water => $composableBuilder(
    column: $table.water,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sewer => $composableBuilder(
    column: $table.sewer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxLengthFt => $composableBuilder(
    column: $table.maxLengthFt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Approach?, Approach, String> get approach =>
      $composableBuilder(
        column: $table.approach,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Shade?, Shade, String> get shade =>
      $composableBuilder(
        column: $table.shade,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Level?, Level, String> get level =>
      $composableBuilder(
        column: $table.level,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get cellBars => $composableBuilder(
    column: $table.cellBars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cellCarrier => $composableBuilder(
    column: $table.cellCarrier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$CampgroundsTableFilterComposer get campgroundId {
    final $$CampgroundsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campgroundId,
      referencedTable: $db.campgrounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampgroundsTableFilterComposer(
            $db: $db,
            $table: $db.campgrounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> visitsRefs(
    Expression<bool> Function($$VisitsTableFilterComposer f) f,
  ) {
    final $$VisitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visits,
      getReferencedColumn: (t) => t.siteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitsTableFilterComposer(
            $db: $db,
            $table: $db.visits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SitesTableOrderingComposer
    extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siteNo => $composableBuilder(
    column: $table.siteNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amps => $composableBuilder(
    column: $table.amps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get water => $composableBuilder(
    column: $table.water,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sewer => $composableBuilder(
    column: $table.sewer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxLengthFt => $composableBuilder(
    column: $table.maxLengthFt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approach => $composableBuilder(
    column: $table.approach,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shade => $composableBuilder(
    column: $table.shade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cellBars => $composableBuilder(
    column: $table.cellBars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cellCarrier => $composableBuilder(
    column: $table.cellCarrier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$CampgroundsTableOrderingComposer get campgroundId {
    final $$CampgroundsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campgroundId,
      referencedTable: $db.campgrounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampgroundsTableOrderingComposer(
            $db: $db,
            $table: $db.campgrounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SitesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get siteNo =>
      $composableBuilder(column: $table.siteNo, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Amps, String> get amps =>
      $composableBuilder(column: $table.amps, builder: (column) => column);

  GeneratedColumn<bool> get water =>
      $composableBuilder(column: $table.water, builder: (column) => column);

  GeneratedColumn<bool> get sewer =>
      $composableBuilder(column: $table.sewer, builder: (column) => column);

  GeneratedColumn<int> get maxLengthFt => $composableBuilder(
    column: $table.maxLengthFt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Approach?, String> get approach =>
      $composableBuilder(column: $table.approach, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Shade?, String> get shade =>
      $composableBuilder(column: $table.shade, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Level?, String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get cellBars =>
      $composableBuilder(column: $table.cellBars, builder: (column) => column);

  GeneratedColumn<String> get cellCarrier => $composableBuilder(
    column: $table.cellCarrier,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$CampgroundsTableAnnotationComposer get campgroundId {
    final $$CampgroundsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.campgroundId,
      referencedTable: $db.campgrounds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CampgroundsTableAnnotationComposer(
            $db: $db,
            $table: $db.campgrounds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> visitsRefs<T extends Object>(
    Expression<T> Function($$VisitsTableAnnotationComposer a) f,
  ) {
    final $$VisitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visits,
      getReferencedColumn: (t) => t.siteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisitsTableAnnotationComposer(
            $db: $db,
            $table: $db.visits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SitesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SitesTable,
          Site,
          $$SitesTableFilterComposer,
          $$SitesTableOrderingComposer,
          $$SitesTableAnnotationComposer,
          $$SitesTableCreateCompanionBuilder,
          $$SitesTableUpdateCompanionBuilder,
          (Site, $$SitesTableReferences),
          Site,
          PrefetchHooks Function({bool campgroundId, bool visitsRefs})
        > {
  $$SitesTableTableManager(_$AppDatabase db, $SitesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> campgroundId = const Value.absent(),
                Value<String> siteNo = const Value.absent(),
                Value<Amps> amps = const Value.absent(),
                Value<bool> water = const Value.absent(),
                Value<bool> sewer = const Value.absent(),
                Value<int?> maxLengthFt = const Value.absent(),
                Value<Approach?> approach = const Value.absent(),
                Value<Shade?> shade = const Value.absent(),
                Value<Level?> level = const Value.absent(),
                Value<int?> cellBars = const Value.absent(),
                Value<String?> cellCarrier = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => SitesCompanion(
                id: id,
                campgroundId: campgroundId,
                siteNo: siteNo,
                amps: amps,
                water: water,
                sewer: sewer,
                maxLengthFt: maxLengthFt,
                approach: approach,
                shade: shade,
                level: level,
                cellBars: cellBars,
                cellCarrier: cellCarrier,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int campgroundId,
                required String siteNo,
                required Amps amps,
                Value<bool> water = const Value.absent(),
                Value<bool> sewer = const Value.absent(),
                Value<int?> maxLengthFt = const Value.absent(),
                Value<Approach?> approach = const Value.absent(),
                Value<Shade?> shade = const Value.absent(),
                Value<Level?> level = const Value.absent(),
                Value<int?> cellBars = const Value.absent(),
                Value<String?> cellCarrier = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => SitesCompanion.insert(
                id: id,
                campgroundId: campgroundId,
                siteNo: siteNo,
                amps: amps,
                water: water,
                sewer: sewer,
                maxLengthFt: maxLengthFt,
                approach: approach,
                shade: shade,
                level: level,
                cellBars: cellBars,
                cellCarrier: cellCarrier,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SitesTable, Site>(table),
                  $$SitesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({campgroundId = false, visitsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (visitsRefs) db.visits],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (campgroundId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.campgroundId,
                                referencedTable: $$SitesTableReferences
                                    ._campgroundIdTable(db),
                                referencedColumn: $$SitesTableReferences
                                    ._campgroundIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (visitsRefs)
                    await $_getPrefetchedData<Site, $SitesTable, Visit>(
                      currentTable: table,
                      referencedTable: $$SitesTableReferences._visitsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$SitesTableReferences(db, table, p0).visitsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.siteId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SitesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SitesTable,
      Site,
      $$SitesTableFilterComposer,
      $$SitesTableOrderingComposer,
      $$SitesTableAnnotationComposer,
      $$SitesTableCreateCompanionBuilder,
      $$SitesTableUpdateCompanionBuilder,
      (Site, $$SitesTableReferences),
      Site,
      PrefetchHooks Function({bool campgroundId, bool visitsRefs})
    >;
typedef $$AppJournalEntriesTableCreateCompanionBuilder =
    AppJournalEntriesCompanion Function({
      Value<int> id,
      Value<String?> notes,
      Value<int?> rating,
      Value<DateTime> createdAt,
    });
typedef $$AppJournalEntriesTableUpdateCompanionBuilder =
    AppJournalEntriesCompanion Function({
      Value<int> id,
      Value<String?> notes,
      Value<int?> rating,
      Value<DateTime> createdAt,
    });

class $$AppJournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AppJournalEntriesTable> {
  $$AppJournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppJournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppJournalEntriesTable> {
  $$AppJournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppJournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppJournalEntriesTable> {
  $$AppJournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AppJournalEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppJournalEntriesTable,
          JournalEntry,
          $$AppJournalEntriesTableFilterComposer,
          $$AppJournalEntriesTableOrderingComposer,
          $$AppJournalEntriesTableAnnotationComposer,
          $$AppJournalEntriesTableCreateCompanionBuilder,
          $$AppJournalEntriesTableUpdateCompanionBuilder,
          (
            JournalEntry,
            BaseReferences<
              _$AppDatabase,
              $AppJournalEntriesTable,
              JournalEntry
            >,
          ),
          JournalEntry,
          PrefetchHooks Function()
        > {
  $$AppJournalEntriesTableTableManager(
    _$AppDatabase db,
    $AppJournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppJournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppJournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppJournalEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AppJournalEntriesCompanion(
                id: id,
                notes: notes,
                rating: rating,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AppJournalEntriesCompanion.insert(
                id: id,
                notes: notes,
                rating: rating,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppJournalEntriesTable, JournalEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppJournalEntriesTable,
                    JournalEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppJournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppJournalEntriesTable,
      JournalEntry,
      $$AppJournalEntriesTableFilterComposer,
      $$AppJournalEntriesTableOrderingComposer,
      $$AppJournalEntriesTableAnnotationComposer,
      $$AppJournalEntriesTableCreateCompanionBuilder,
      $$AppJournalEntriesTableUpdateCompanionBuilder,
      (
        JournalEntry,
        BaseReferences<_$AppDatabase, $AppJournalEntriesTable, JournalEntry>,
      ),
      JournalEntry,
      PrefetchHooks Function()
    >;
typedef $$VisitsTableCreateCompanionBuilder =
    VisitsCompanion Function({
      Value<int> id,
      required int siteId,
      required DateTime arrive,
      required DateTime depart,
      Value<int?> costTotalCents,
      Value<int?> journalEntryId,
    });
typedef $$VisitsTableUpdateCompanionBuilder =
    VisitsCompanion Function({
      Value<int> id,
      Value<int> siteId,
      Value<DateTime> arrive,
      Value<DateTime> depart,
      Value<int?> costTotalCents,
      Value<int?> journalEntryId,
    });

final class $$VisitsTableReferences
    extends BaseReferences<_$AppDatabase, $VisitsTable, Visit> {
  $$VisitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SitesTable _siteIdTable(_$AppDatabase db) =>
      db.sites.createAlias('visits__site_id__sites__id');

  $$SitesTableProcessedTableManager get siteId {
    final $_column = $_itemColumn<int>('site_id')!;

    final manager = $$SitesTableTableManager(
      $_db,
      $_db.sites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_siteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VisitsTableFilterComposer
    extends Composer<_$AppDatabase, $VisitsTable> {
  $$VisitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get arrive => $composableBuilder(
    column: $table.arrive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get depart => $composableBuilder(
    column: $table.depart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costTotalCents => $composableBuilder(
    column: $table.costTotalCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => ColumnFilters(column),
  );

  $$SitesTableFilterComposer get siteId {
    final $$SitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableFilterComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitsTableOrderingComposer
    extends Composer<_$AppDatabase, $VisitsTable> {
  $$VisitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get arrive => $composableBuilder(
    column: $table.arrive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get depart => $composableBuilder(
    column: $table.depart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costTotalCents => $composableBuilder(
    column: $table.costTotalCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => ColumnOrderings(column),
  );

  $$SitesTableOrderingComposer get siteId {
    final $$SitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableOrderingComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VisitsTable> {
  $$VisitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get arrive =>
      $composableBuilder(column: $table.arrive, builder: (column) => column);

  GeneratedColumn<DateTime> get depart =>
      $composableBuilder(column: $table.depart, builder: (column) => column);

  GeneratedColumn<int> get costTotalCents => $composableBuilder(
    column: $table.costTotalCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => column,
  );

  $$SitesTableAnnotationComposer get siteId {
    final $$SitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.siteId,
      referencedTable: $db.sites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SitesTableAnnotationComposer(
            $db: $db,
            $table: $db.sites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VisitsTable,
          Visit,
          $$VisitsTableFilterComposer,
          $$VisitsTableOrderingComposer,
          $$VisitsTableAnnotationComposer,
          $$VisitsTableCreateCompanionBuilder,
          $$VisitsTableUpdateCompanionBuilder,
          (Visit, $$VisitsTableReferences),
          Visit,
          PrefetchHooks Function({bool siteId})
        > {
  $$VisitsTableTableManager(_$AppDatabase db, $VisitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> siteId = const Value.absent(),
                Value<DateTime> arrive = const Value.absent(),
                Value<DateTime> depart = const Value.absent(),
                Value<int?> costTotalCents = const Value.absent(),
                Value<int?> journalEntryId = const Value.absent(),
              }) => VisitsCompanion(
                id: id,
                siteId: siteId,
                arrive: arrive,
                depart: depart,
                costTotalCents: costTotalCents,
                journalEntryId: journalEntryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int siteId,
                required DateTime arrive,
                required DateTime depart,
                Value<int?> costTotalCents = const Value.absent(),
                Value<int?> journalEntryId = const Value.absent(),
              }) => VisitsCompanion.insert(
                id: id,
                siteId: siteId,
                arrive: arrive,
                depart: depart,
                costTotalCents: costTotalCents,
                journalEntryId: journalEntryId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VisitsTable, Visit>(table),
                  $$VisitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({siteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (siteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.siteId,
                                referencedTable: $$VisitsTableReferences
                                    ._siteIdTable(db),
                                referencedColumn: $$VisitsTableReferences
                                    ._siteIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VisitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VisitsTable,
      Visit,
      $$VisitsTableFilterComposer,
      $$VisitsTableOrderingComposer,
      $$VisitsTableAnnotationComposer,
      $$VisitsTableCreateCompanionBuilder,
      $$VisitsTableUpdateCompanionBuilder,
      (Visit, $$VisitsTableReferences),
      Visit,
      PrefetchHooks Function({bool siteId})
    >;
typedef $$RigsTableCreateCompanionBuilder =
    RigsCompanion Function({
      Value<int> id,
      required String name,
      required RigKind kind,
      Value<int?> lengthFt,
      Value<int?> gvwrLbs,
      Value<String?> ballSizeIn,
      Value<int?> hitchDropIn,
      Value<String?> wdBarSetting,
      Value<int?> tirePsiFront,
      Value<int?> tirePsiRear,
      Value<int?> brakeGain,
      Value<DateTime?> bearingServiceDate,
      Value<DateTime?> tireDate,
      Value<int?> journalEntryId,
    });
typedef $$RigsTableUpdateCompanionBuilder =
    RigsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<RigKind> kind,
      Value<int?> lengthFt,
      Value<int?> gvwrLbs,
      Value<String?> ballSizeIn,
      Value<int?> hitchDropIn,
      Value<String?> wdBarSetting,
      Value<int?> tirePsiFront,
      Value<int?> tirePsiRear,
      Value<int?> brakeGain,
      Value<DateTime?> bearingServiceDate,
      Value<DateTime?> tireDate,
      Value<int?> journalEntryId,
    });

class $$RigsTableFilterComposer extends Composer<_$AppDatabase, $RigsTable> {
  $$RigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RigKind, RigKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get lengthFt => $composableBuilder(
    column: $table.lengthFt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gvwrLbs => $composableBuilder(
    column: $table.gvwrLbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ballSizeIn => $composableBuilder(
    column: $table.ballSizeIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hitchDropIn => $composableBuilder(
    column: $table.hitchDropIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wdBarSetting => $composableBuilder(
    column: $table.wdBarSetting,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tirePsiFront => $composableBuilder(
    column: $table.tirePsiFront,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tirePsiRear => $composableBuilder(
    column: $table.tirePsiRear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get brakeGain => $composableBuilder(
    column: $table.brakeGain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get bearingServiceDate => $composableBuilder(
    column: $table.bearingServiceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tireDate => $composableBuilder(
    column: $table.tireDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RigsTableOrderingComposer extends Composer<_$AppDatabase, $RigsTable> {
  $$RigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lengthFt => $composableBuilder(
    column: $table.lengthFt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gvwrLbs => $composableBuilder(
    column: $table.gvwrLbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ballSizeIn => $composableBuilder(
    column: $table.ballSizeIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hitchDropIn => $composableBuilder(
    column: $table.hitchDropIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wdBarSetting => $composableBuilder(
    column: $table.wdBarSetting,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tirePsiFront => $composableBuilder(
    column: $table.tirePsiFront,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tirePsiRear => $composableBuilder(
    column: $table.tirePsiRear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get brakeGain => $composableBuilder(
    column: $table.brakeGain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get bearingServiceDate => $composableBuilder(
    column: $table.bearingServiceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tireDate => $composableBuilder(
    column: $table.tireDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RigsTable> {
  $$RigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RigKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get lengthFt =>
      $composableBuilder(column: $table.lengthFt, builder: (column) => column);

  GeneratedColumn<int> get gvwrLbs =>
      $composableBuilder(column: $table.gvwrLbs, builder: (column) => column);

  GeneratedColumn<String> get ballSizeIn => $composableBuilder(
    column: $table.ballSizeIn,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hitchDropIn => $composableBuilder(
    column: $table.hitchDropIn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get wdBarSetting => $composableBuilder(
    column: $table.wdBarSetting,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tirePsiFront => $composableBuilder(
    column: $table.tirePsiFront,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tirePsiRear => $composableBuilder(
    column: $table.tirePsiRear,
    builder: (column) => column,
  );

  GeneratedColumn<int> get brakeGain =>
      $composableBuilder(column: $table.brakeGain, builder: (column) => column);

  GeneratedColumn<DateTime> get bearingServiceDate => $composableBuilder(
    column: $table.bearingServiceDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get tireDate =>
      $composableBuilder(column: $table.tireDate, builder: (column) => column);

  GeneratedColumn<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => column,
  );
}

class $$RigsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RigsTable,
          Rig,
          $$RigsTableFilterComposer,
          $$RigsTableOrderingComposer,
          $$RigsTableAnnotationComposer,
          $$RigsTableCreateCompanionBuilder,
          $$RigsTableUpdateCompanionBuilder,
          (Rig, BaseReferences<_$AppDatabase, $RigsTable, Rig>),
          Rig,
          PrefetchHooks Function()
        > {
  $$RigsTableTableManager(_$AppDatabase db, $RigsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<RigKind> kind = const Value.absent(),
                Value<int?> lengthFt = const Value.absent(),
                Value<int?> gvwrLbs = const Value.absent(),
                Value<String?> ballSizeIn = const Value.absent(),
                Value<int?> hitchDropIn = const Value.absent(),
                Value<String?> wdBarSetting = const Value.absent(),
                Value<int?> tirePsiFront = const Value.absent(),
                Value<int?> tirePsiRear = const Value.absent(),
                Value<int?> brakeGain = const Value.absent(),
                Value<DateTime?> bearingServiceDate = const Value.absent(),
                Value<DateTime?> tireDate = const Value.absent(),
                Value<int?> journalEntryId = const Value.absent(),
              }) => RigsCompanion(
                id: id,
                name: name,
                kind: kind,
                lengthFt: lengthFt,
                gvwrLbs: gvwrLbs,
                ballSizeIn: ballSizeIn,
                hitchDropIn: hitchDropIn,
                wdBarSetting: wdBarSetting,
                tirePsiFront: tirePsiFront,
                tirePsiRear: tirePsiRear,
                brakeGain: brakeGain,
                bearingServiceDate: bearingServiceDate,
                tireDate: tireDate,
                journalEntryId: journalEntryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required RigKind kind,
                Value<int?> lengthFt = const Value.absent(),
                Value<int?> gvwrLbs = const Value.absent(),
                Value<String?> ballSizeIn = const Value.absent(),
                Value<int?> hitchDropIn = const Value.absent(),
                Value<String?> wdBarSetting = const Value.absent(),
                Value<int?> tirePsiFront = const Value.absent(),
                Value<int?> tirePsiRear = const Value.absent(),
                Value<int?> brakeGain = const Value.absent(),
                Value<DateTime?> bearingServiceDate = const Value.absent(),
                Value<DateTime?> tireDate = const Value.absent(),
                Value<int?> journalEntryId = const Value.absent(),
              }) => RigsCompanion.insert(
                id: id,
                name: name,
                kind: kind,
                lengthFt: lengthFt,
                gvwrLbs: gvwrLbs,
                ballSizeIn: ballSizeIn,
                hitchDropIn: hitchDropIn,
                wdBarSetting: wdBarSetting,
                tirePsiFront: tirePsiFront,
                tirePsiRear: tirePsiRear,
                brakeGain: brakeGain,
                bearingServiceDate: bearingServiceDate,
                tireDate: tireDate,
                journalEntryId: journalEntryId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RigsTable, Rig>(table),
                  BaseReferences<_$AppDatabase, $RigsTable, Rig>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RigsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RigsTable,
      Rig,
      $$RigsTableFilterComposer,
      $$RigsTableOrderingComposer,
      $$RigsTableAnnotationComposer,
      $$RigsTableCreateCompanionBuilder,
      $$RigsTableUpdateCompanionBuilder,
      (Rig, BaseReferences<_$AppDatabase, $RigsTable, Rig>),
      Rig,
      PrefetchHooks Function()
    >;
typedef $$AppJournalPhotosTableCreateCompanionBuilder =
    AppJournalPhotosCompanion Function({
      Value<int> id,
      required int entryId,
      required String path,
      Value<String?> caption,
    });
typedef $$AppJournalPhotosTableUpdateCompanionBuilder =
    AppJournalPhotosCompanion Function({
      Value<int> id,
      Value<int> entryId,
      Value<String> path,
      Value<String?> caption,
    });

class $$AppJournalPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $AppJournalPhotosTable> {
  $$AppJournalPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppJournalPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $AppJournalPhotosTable> {
  $$AppJournalPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppJournalPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppJournalPhotosTable> {
  $$AppJournalPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get entryId =>
      $composableBuilder(column: $table.entryId, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);
}

class $$AppJournalPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppJournalPhotosTable,
          JournalPhoto,
          $$AppJournalPhotosTableFilterComposer,
          $$AppJournalPhotosTableOrderingComposer,
          $$AppJournalPhotosTableAnnotationComposer,
          $$AppJournalPhotosTableCreateCompanionBuilder,
          $$AppJournalPhotosTableUpdateCompanionBuilder,
          (
            JournalPhoto,
            BaseReferences<_$AppDatabase, $AppJournalPhotosTable, JournalPhoto>,
          ),
          JournalPhoto,
          PrefetchHooks Function()
        > {
  $$AppJournalPhotosTableTableManager(
    _$AppDatabase db,
    $AppJournalPhotosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppJournalPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppJournalPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppJournalPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> entryId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String?> caption = const Value.absent(),
              }) => AppJournalPhotosCompanion(
                id: id,
                entryId: entryId,
                path: path,
                caption: caption,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int entryId,
                required String path,
                Value<String?> caption = const Value.absent(),
              }) => AppJournalPhotosCompanion.insert(
                id: id,
                entryId: entryId,
                path: path,
                caption: caption,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppJournalPhotosTable, JournalPhoto>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppJournalPhotosTable,
                    JournalPhoto
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppJournalPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppJournalPhotosTable,
      JournalPhoto,
      $$AppJournalPhotosTableFilterComposer,
      $$AppJournalPhotosTableOrderingComposer,
      $$AppJournalPhotosTableAnnotationComposer,
      $$AppJournalPhotosTableCreateCompanionBuilder,
      $$AppJournalPhotosTableUpdateCompanionBuilder,
      (
        JournalPhoto,
        BaseReferences<_$AppDatabase, $AppJournalPhotosTable, JournalPhoto>,
      ),
      JournalPhoto,
      PrefetchHooks Function()
    >;
typedef $$AppJournalTagsTableCreateCompanionBuilder =
    AppJournalTagsCompanion Function({
      Value<int> id,
      required int entryId,
      required String tag,
    });
typedef $$AppJournalTagsTableUpdateCompanionBuilder =
    AppJournalTagsCompanion Function({
      Value<int> id,
      Value<int> entryId,
      Value<String> tag,
    });

class $$AppJournalTagsTableFilterComposer
    extends Composer<_$AppDatabase, $AppJournalTagsTable> {
  $$AppJournalTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppJournalTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppJournalTagsTable> {
  $$AppJournalTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppJournalTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppJournalTagsTable> {
  $$AppJournalTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get entryId =>
      $composableBuilder(column: $table.entryId, builder: (column) => column);

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);
}

class $$AppJournalTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppJournalTagsTable,
          JournalTag,
          $$AppJournalTagsTableFilterComposer,
          $$AppJournalTagsTableOrderingComposer,
          $$AppJournalTagsTableAnnotationComposer,
          $$AppJournalTagsTableCreateCompanionBuilder,
          $$AppJournalTagsTableUpdateCompanionBuilder,
          (
            JournalTag,
            BaseReferences<_$AppDatabase, $AppJournalTagsTable, JournalTag>,
          ),
          JournalTag,
          PrefetchHooks Function()
        > {
  $$AppJournalTagsTableTableManager(
    _$AppDatabase db,
    $AppJournalTagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppJournalTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppJournalTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppJournalTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> entryId = const Value.absent(),
                Value<String> tag = const Value.absent(),
              }) => AppJournalTagsCompanion(id: id, entryId: entryId, tag: tag),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int entryId,
                required String tag,
              }) => AppJournalTagsCompanion.insert(
                id: id,
                entryId: entryId,
                tag: tag,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppJournalTagsTable, JournalTag>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppJournalTagsTable,
                    JournalTag
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppJournalTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppJournalTagsTable,
      JournalTag,
      $$AppJournalTagsTableFilterComposer,
      $$AppJournalTagsTableOrderingComposer,
      $$AppJournalTagsTableAnnotationComposer,
      $$AppJournalTagsTableCreateCompanionBuilder,
      $$AppJournalTagsTableUpdateCompanionBuilder,
      (
        JournalTag,
        BaseReferences<_$AppDatabase, $AppJournalTagsTable, JournalTag>,
      ),
      JournalTag,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CampgroundsTableTableManager get campgrounds =>
      $$CampgroundsTableTableManager(_db, _db.campgrounds);
  $$SitesTableTableManager get sites =>
      $$SitesTableTableManager(_db, _db.sites);
  $$AppJournalEntriesTableTableManager get appJournalEntries =>
      $$AppJournalEntriesTableTableManager(_db, _db.appJournalEntries);
  $$VisitsTableTableManager get visits =>
      $$VisitsTableTableManager(_db, _db.visits);
  $$RigsTableTableManager get rigs => $$RigsTableTableManager(_db, _db.rigs);
  $$AppJournalPhotosTableTableManager get appJournalPhotos =>
      $$AppJournalPhotosTableTableManager(_db, _db.appJournalPhotos);
  $$AppJournalTagsTableTableManager get appJournalTags =>
      $$AppJournalTagsTableTableManager(_db, _db.appJournalTags);
}
