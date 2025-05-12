// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomCardAnswerTypeAdapter extends TypeAdapter<CustomCardAnswerType> {
  @override
  final int typeId = 8;

  @override
  CustomCardAnswerType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CustomCardAnswerType.text;
      case 1:
        return CustomCardAnswerType.choice;
      case 2:
        return CustomCardAnswerType.calendar;
      case 3:
        return CustomCardAnswerType.numberText;
      case 4:
        return CustomCardAnswerType.social;
      default:
        return CustomCardAnswerType.text;
    }
  }

  @override
  void write(BinaryWriter writer, CustomCardAnswerType obj) {
    switch (obj) {
      case CustomCardAnswerType.text:
        writer.writeByte(0);
        break;
      case CustomCardAnswerType.choice:
        writer.writeByte(1);
        break;
      case CustomCardAnswerType.calendar:
        writer.writeByte(2);
        break;
      case CustomCardAnswerType.numberText:
        writer.writeByte(3);
        break;
      case CustomCardAnswerType.social:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomCardAnswerTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserOnboardStatusAdapter extends TypeAdapter<UserOnboardStatus> {
  @override
  final int typeId = 0;

  @override
  UserOnboardStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserOnboardStatus.initial;
      case 1:
        return UserOnboardStatus.onboardDone;
      case 2:
        return UserOnboardStatus.signUpForm;
      case 3:
        return UserOnboardStatus.loggedIn;
      default:
        return UserOnboardStatus.initial;
    }
  }

  @override
  void write(BinaryWriter writer, UserOnboardStatus obj) {
    switch (obj) {
      case UserOnboardStatus.initial:
        writer.writeByte(0);
        break;
      case UserOnboardStatus.onboardDone:
        writer.writeByte(1);
        break;
      case UserOnboardStatus.signUpForm:
        writer.writeByte(2);
        break;
      case UserOnboardStatus.loggedIn:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserOnboardStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OnboardStatusAdapter extends TypeAdapter<OnboardStatus> {
  @override
  final int typeId = 9;

  @override
  OnboardStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OnboardStatus.authenticated;
      case 1:
        return OnboardStatus.signed_up;
      default:
        return OnboardStatus.authenticated;
    }
  }

  @override
  void write(BinaryWriter writer, OnboardStatus obj) {
    switch (obj) {
      case OnboardStatus.authenticated:
        writer.writeByte(0);
        break;
      case OnboardStatus.signed_up:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EntityAdapter extends TypeAdapter<Entity> {
  @override
  final int typeId = 2;

  @override
  Entity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Entity.user;
      case 1:
        return Entity.agent;
      case 2:
        return Entity.button_Admin;
      default:
        return Entity.user;
    }
  }

  @override
  void write(BinaryWriter writer, Entity obj) {
    switch (obj) {
      case Entity.user:
        writer.writeByte(0);
        break;
      case Entity.agent:
        writer.writeByte(1);
        break;
      case Entity.button_Admin:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AgentApprovalStatusAdapter extends TypeAdapter<AgentApprovalStatus> {
  @override
  final int typeId = 4;

  @override
  AgentApprovalStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AgentApprovalStatus.approved;
      case 1:
        return AgentApprovalStatus.pending;
      case 2:
        return AgentApprovalStatus.denied;
      default:
        return AgentApprovalStatus.approved;
    }
  }

  @override
  void write(BinaryWriter writer, AgentApprovalStatus obj) {
    switch (obj) {
      case AgentApprovalStatus.approved:
        writer.writeByte(0);
        break;
      case AgentApprovalStatus.pending:
        writer.writeByte(1);
        break;
      case AgentApprovalStatus.denied:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentApprovalStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BrandApprovalStatusAdapter extends TypeAdapter<BrandApprovalStatus> {
  @override
  final int typeId = 10;

  @override
  BrandApprovalStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BrandApprovalStatus.approved;
      case 1:
        return BrandApprovalStatus.pending;
      case 2:
        return BrandApprovalStatus.denied;
      default:
        return BrandApprovalStatus.approved;
    }
  }

  @override
  void write(BinaryWriter writer, BrandApprovalStatus obj) {
    switch (obj) {
      case BrandApprovalStatus.approved:
        writer.writeByte(0);
        break;
      case BrandApprovalStatus.pending:
        writer.writeByte(1);
        break;
      case BrandApprovalStatus.denied:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandApprovalStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AgentRoleAdapter extends TypeAdapter<AgentRole> {
  @override
  final int typeId = 12;

  @override
  AgentRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AgentRole.Admin;
      case 1:
        return AgentRole.Owner;
      case 2:
        return AgentRole.InventoryManager;
      case 3:
        return AgentRole.SalesManager;
      case 4:
        return AgentRole.ContentManager;
      case 5:
        return AgentRole.SalesAgent;
      case 6:
        return AgentRole.Support;
      default:
        return AgentRole.Admin;
    }
  }

  @override
  void write(BinaryWriter writer, AgentRole obj) {
    switch (obj) {
      case AgentRole.Admin:
        writer.writeByte(0);
        break;
      case AgentRole.Owner:
        writer.writeByte(1);
        break;
      case AgentRole.InventoryManager:
        writer.writeByte(2);
        break;
      case AgentRole.SalesManager:
        writer.writeByte(3);
        break;
      case AgentRole.ContentManager:
        writer.writeByte(4);
        break;
      case AgentRole.SalesAgent:
        writer.writeByte(5);
        break;
      case AgentRole.Support:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgentRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
