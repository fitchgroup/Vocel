/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the VocelEvent type in your schema. */
@immutable
class VocelEvent extends Model {
  static const classType = const _VocelEventModelType();
  final String id;
  final String? _eventTitle;
  final String? _eventLocation;
  final ProfileRole? _eventGroup;
  final String? _eventDescription;
  final TemporalDateTime? _startTime;
  final int? _duration;
  final String? _eventImageUrl;
  final String? _eventImageKey;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  VocelEventModelIdentifier get modelIdentifier {
    return VocelEventModelIdentifier(id: id);
  }

  String get eventTitle {
    try {
      return _eventTitle!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get eventLocation {
    try {
      return _eventLocation!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  ProfileRole get eventGroup {
    try {
      return _eventGroup!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get eventDescription {
    try {
      return _eventDescription!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  TemporalDateTime get startTime {
    try {
      return _startTime!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  int get duration {
    try {
      return _duration!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String? get eventImageUrl {
    return _eventImageUrl;
  }

  String? get eventImageKey {
    return _eventImageKey;
  }

  TemporalDateTime? get createdAt {
    return _createdAt;
  }

  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const VocelEvent._internal(
      {required this.id,
      required eventTitle,
      required eventLocation,
      required eventGroup,
      required eventDescription,
      required startTime,
      required duration,
      eventImageUrl,
      eventImageKey,
      createdAt,
      updatedAt})
      : _eventTitle = eventTitle,
        _eventLocation = eventLocation,
        _eventGroup = eventGroup,
        _eventDescription = eventDescription,
        _startTime = startTime,
        _duration = duration,
        _eventImageUrl = eventImageUrl,
        _eventImageKey = eventImageKey,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory VocelEvent(
      {String? id,
      required String eventTitle,
      required String eventLocation,
      required ProfileRole eventGroup,
      required String eventDescription,
      required TemporalDateTime startTime,
      required int duration,
      String? eventImageUrl,
      String? eventImageKey}) {
    return VocelEvent._internal(
        id: id == null ? UUID.getUUID() : id,
        eventTitle: eventTitle,
        eventLocation: eventLocation,
        eventGroup: eventGroup,
        eventDescription: eventDescription,
        startTime: startTime,
        duration: duration,
        eventImageUrl: eventImageUrl,
        eventImageKey: eventImageKey,
        createdAt: TemporalDateTime.now());
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VocelEvent &&
        id == other.id &&
        _eventTitle == other._eventTitle &&
        _eventLocation == other._eventLocation &&
        _eventGroup == other._eventGroup &&
        _eventDescription == other._eventDescription &&
        _startTime == other._startTime &&
        _duration == other._duration &&
        _eventImageUrl == other._eventImageUrl &&
        _eventImageKey == other._eventImageKey;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("VocelEvent {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("eventTitle=" + "$_eventTitle" + ", ");
    buffer.write("eventLocation=" + "$_eventLocation" + ", ");
    buffer.write("eventGroup=" +
        (_eventGroup != null ? enumToString(_eventGroup)! : "null") +
        ", ");
    buffer.write("eventDescription=" + "$_eventDescription" + ", ");
    buffer.write("startTime=" +
        (_startTime != null ? _startTime!.format() : "null") +
        ", ");
    buffer.write("duration=" +
        (_duration != null ? _duration!.toString() : "null") +
        ", ");
    buffer.write("eventImageUrl=" + "$_eventImageUrl" + ", ");
    buffer.write("eventImageKey=" + "$_eventImageKey" + ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  VocelEvent copyWith(
      {String? eventTitle,
      String? eventLocation,
      ProfileRole? eventGroup,
      String? eventDescription,
      TemporalDateTime? startTime,
      int? duration,
      String? eventImageUrl,
      String? eventImageKey}) {
    return VocelEvent._internal(
        id: id,
        eventTitle: eventTitle ?? this.eventTitle,
        eventLocation: eventLocation ?? this.eventLocation,
        eventGroup: eventGroup ?? this.eventGroup,
        eventDescription: eventDescription ?? this.eventDescription,
        startTime: startTime ?? this.startTime,
        duration: duration ?? this.duration,
        eventImageUrl: eventImageUrl ?? this.eventImageUrl,
        eventImageKey: eventImageKey ?? this.eventImageKey);
  }

  VocelEvent.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _eventTitle = json['eventTitle'],
        _eventLocation = json['eventLocation'],
        _eventGroup =
            enumFromString<ProfileRole>(json['eventGroup'], ProfileRole.values),
        _eventDescription = json['eventDescription'],
        _startTime = json['startTime'] != null
            ? TemporalDateTime.fromString(json['startTime'])
            : null,
        _duration = (json['duration'] as num?)?.toInt(),
        _eventImageUrl = json['eventImageUrl'],
        _eventImageKey = json['eventImageKey'],
        _createdAt = json['createdAt'] != null
            ? TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventTitle': _eventTitle,
        'eventLocation': _eventLocation,
        'eventGroup': enumToString(_eventGroup),
        'eventDescription': _eventDescription,
        'startTime': _startTime?.format(),
        'duration': _duration,
        'eventImageUrl': _eventImageUrl,
        'eventImageKey': _eventImageKey,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'eventTitle': _eventTitle,
        'eventLocation': _eventLocation,
        'eventGroup': _eventGroup,
        'eventDescription': _eventDescription,
        'startTime': _startTime,
        'duration': _duration,
        'eventImageUrl': _eventImageUrl,
        'eventImageKey': _eventImageKey,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final QueryModelIdentifier<VocelEventModelIdentifier>
      MODEL_IDENTIFIER = QueryModelIdentifier<VocelEventModelIdentifier>();
  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField EVENTTITLE = QueryField(fieldName: "eventTitle");
  static final QueryField EVENTLOCATION =
      QueryField(fieldName: "eventLocation");
  static final QueryField EVENTGROUP = QueryField(fieldName: "eventGroup");
  static final QueryField EVENTDESCRIPTION =
      QueryField(fieldName: "eventDescription");
  static final QueryField STARTTIME = QueryField(fieldName: "startTime");
  static final QueryField DURATION = QueryField(fieldName: "duration");
  static final QueryField EVENTIMAGEURL =
      QueryField(fieldName: "eventImageUrl");
  static final QueryField EVENTIMAGEKEY =
      QueryField(fieldName: "eventImageKey");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "VocelEvent";
    modelSchemaDefinition.pluralName = "VocelEvents";

    modelSchemaDefinition.authRules = [
      AuthRule(
          authStrategy: AuthStrategy.OWNER,
          ownerField: "owner",
          identityClaim: "cognito:username",
          provider: AuthRuleProvider.USERPOOLS,
          operations: [
            ModelOperation.UPDATE,
            ModelOperation.READ,
            ModelOperation.CREATE,
            ModelOperation.DELETE
          ]),
      AuthRule(
          authStrategy: AuthStrategy.GROUPS,
          groupClaim: "cognito:groups",
          groups: ["Staffversion1"],
          provider: AuthRuleProvider.USERPOOLS,
          operations: [
            ModelOperation.CREATE,
            ModelOperation.UPDATE,
            ModelOperation.DELETE,
            ModelOperation.READ
          ]),
      AuthRule(
          authStrategy: AuthStrategy.PUBLIC, operations: [ModelOperation.READ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: VocelEvent.EVENTTITLE,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: VocelEvent.EVENTLOCATION,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: VocelEvent.EVENTGROUP,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: VocelEvent.EVENTDESCRIPTION,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: VocelEvent.STARTTIME,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: VocelEvent.DURATION,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: VocelEvent.EVENTIMAGEURL,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: VocelEvent.EVENTIMAGEKEY,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
        fieldName: 'createdAt',
        isRequired: false,
        isReadOnly: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
        fieldName: 'updatedAt',
        isRequired: false,
        isReadOnly: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));
  });
}

class _VocelEventModelType extends ModelType<VocelEvent> {
  const _VocelEventModelType();

  @override
  VocelEvent fromJson(Map<String, dynamic> jsonData) {
    return VocelEvent.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'VocelEvent';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [VocelEvent] in your schema.
 */
@immutable
class VocelEventModelIdentifier implements ModelIdentifier<VocelEvent> {
  final String id;

  /** Create an instance of VocelEventModelIdentifier using [id] the primary key. */
  const VocelEventModelIdentifier({required this.id});

  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{'id': id});

  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
      .entries
      .map((entry) => (<String, dynamic>{entry.key: entry.value}))
      .toList();

  @override
  String serializeAsString() => serializeAsMap().values.join('#');

  @override
  String toString() => 'VocelEventModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is VocelEventModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
