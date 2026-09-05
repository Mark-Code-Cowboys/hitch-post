import '../../data/database/app_database.dart';

extension CampgroundKindLabel on CampgroundKind {
  String get label => switch (this) {
        CampgroundKind.public => 'Public',
        CampgroundKind.private => 'Private',
        CampgroundKind.statePark => 'State park',
        CampgroundKind.nationalPark => 'National park',
        CampgroundKind.coe => 'COE',
        CampgroundKind.boondock => 'Boondock',
        CampgroundKind.other => 'Other',
      };
}

extension AmpsLabel on Amps {
  String get label => switch (this) {
        Amps.none => 'No power',
        Amps.a15 => '15A',
        Amps.a30 => '30A',
        Amps.a50 => '50A',
      };
}

extension ApproachLabel on Approach {
  String get label => switch (this) {
        Approach.pullThru => 'Pull-thru',
        Approach.backIn => 'Back-in',
      };
}

extension ShadeLabel on Shade {
  String get label => switch (this) {
        Shade.full => 'Full shade',
        Shade.partial => 'Partial shade',
        Shade.none => 'No shade',
      };
}

extension LevelLabel on Level {
  String get label => switch (this) {
        Level.yes => 'Level',
        Level.workable => 'Workable',
        Level.no => 'Not level',
      };
}

extension RigKindLabel on RigKind {
  String get label => switch (this) {
        RigKind.travelTrailer => 'Travel trailer',
        RigKind.fifthWheel => 'Fifth wheel',
        RigKind.motorhome => 'Motorhome',
        RigKind.camperVan => 'Camper van',
        RigKind.truckCamper => 'Truck camper',
      };
}
