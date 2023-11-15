import 'package:emp_data/models/team.dart';
import 'package:hive/hive.dart';

class TeamHiveAdapter extends TypeAdapter<Team> {
  @override
  Team read(BinaryReader reader) {
    final id = reader.readString();
    final domain = reader.readString();
    return Team(id, domain: domain);
  }

  @override
  void write(BinaryWriter writer, Team member) {
    writer.writeString(member.id);
    writer.writeString(member.domain);
  }

  @override
  int get typeId => 0;
}
