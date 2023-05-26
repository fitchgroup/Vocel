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

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Event type in your schema. */
@immutable
class Event extends Model {
  static const classType = const _EventModelType();
  final String id;
  final String? _eventTitle;
  final String? _eventLocation;
  final String? _eventDescription;
  final TemporalDateTime? _startTime;
  final int? _duration;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  EventModelIdentifier get modelIdentifier {
      return EventModelIdentifier(
        id: id
      );
  }
  
  String get eventTitle {
    try {
      return _eventTitle!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get eventLocation {
    try {
      return _eventLocation!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get eventDescription {
    try {
      return _eventDescription!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime get startTime {
    try {
      return _startTime!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get duration {
    try {
      return _duration!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Event._internal({required this.id, required eventTitle, required eventLocation, required eventDescription, required startTime, required duration, createdAt, updatedAt}): _eventTitle = eventTitle, _eventLocation = eventLocation, _eventDescription = eventDescription, _startTime = startTime, _duration = duration, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Event({String? id, required String eventTitle, required String eventLocation, required String eventDescription, required TemporalDateTime startTime, required int duration}) {
    return Event._internal(
      id: id == null ? UUID.getUUID() : id,
      eventTitle: eventTitle,
      eventLocation: eventLocation,
      eventDescription: eventDescription,
      startTime: startTime,
      duration: duration);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Event &&
      id == other.id &&
      _eventTitle == other._eventTitle &&
      _eventLocation == other._eventLocation &&
      _eventDescription == other._eventDescription &&
      _startTime == other._startTime &&
      _duration == other._duration;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Event {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("eventTitle=" + "$_eventTitle" + ", ");
    buffer.write("eventLocation=" + "$_eventLocation" + ", ");
    buffer.write("eventDescription=" + "$_eventDescription" + ", ");
    buffer.write("startTime=" + (_startTime != null ? _startTime!.format() : "null") + ", ");
    buffer.write("duration=" + (_duration != null ? _duration!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Event copyWith({String? eventTitle, String? eventLocation, String? eventDescription, TemporalDateTime? startTime, int? duration}) {
    return Event._internal(
      id: id,
      eventTitle: eventTitle ?? this.eventTitle,
      eventLocation: eventLocation ?? this.eventLocation,
      eventDescription: eventDescription ?? this.eventDescription,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration);
  }
  
  Event.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _eventTitle = json['eventTitle'],
      _eventLocation = json['eventLocation'],
      _eventDescription = json['eventDescription'],
      _startTime = json['startTime'] != null ? TemporalDateTime.fromString(json['startTime']) : null,
      _duration = (json['duration'] as num?)?.toInt(),
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'eventTitle': _eventTitle, 'eventLocation': _eventLocation, 'eventDescription': _eventDescription, 'startTime': _startTime?.format(), 'duration': _duration, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id, 'eventTitle': _eventTitle, 'eventLocation': _eventLocation, 'eventDescription': _eventDescription, 'startTime': _startTime, 'duration': _duration, 'createdAt': _createdAt, 'updatedAt': _updatedAt
  };

  static final QueryModelIdentifier<EventModelIdentifier> MODEL_IDENTIFIER = QueryModelIdentifier<EventModelIdentifier>();
  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField EVENTTITLE = QueryField(fieldName: "eventTitle");
  static final QueryField EVENTLOCATION = QueryField(fieldName: "eventLocation");
  static final QueryField EVENTDESCRIPTION = QueryField(fieldName: "eventDescription");
  static final QueryField STARTTIME = QueryField(fieldName: "startTime");
  static final QueryField DURATION = QueryField(fieldName: "duration");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Event";
    modelSchemaDefinition.pluralName = "Events";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: AuthRuleProvider.USERPOOLS,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Event.EVENTTITLE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Event.EVENTLOCATION,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Event.EVENTDESCRIPTION,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Event.STARTTIME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Event.DURATION,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _EventModelType extends ModelType<Event> {
  const _EventModelType();
  
  @override
  Event fromJson(Map<String, dynamic> jsonData) {
    return Event.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Event';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Event] in your schema.
 */
@immutable
class EventModelIdentifier implements ModelIdentifier<Event> {
  final String id;

  /** Create an instance of EventModelIdentifier using [id] the primary key. */
  const EventModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'EventModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is EventModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}