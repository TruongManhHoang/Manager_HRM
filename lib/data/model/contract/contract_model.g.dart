// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContractModelAdapter extends TypeAdapter<ContractModel> {
  @override
  final int typeId = 4;

  @override
  ContractModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContractModel(
      id: fields[0] as String?,
      contractCode: fields[1] as String?,
      employeeId: fields[2] as String?,
      contractType: fields[3] as String,
      salary: fields[4] as int,
      description: fields[5] as String,
      startDate: fields[6] as DateTime?,
      endDate: fields[7] as DateTime?,
      createdAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
      status: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ContractModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.contractCode)
      ..writeByte(2)
      ..write(obj.employeeId)
      ..writeByte(3)
      ..write(obj.contractType)
      ..writeByte(4)
      ..write(obj.salary)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContractModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
