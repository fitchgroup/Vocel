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


/** This is an auto generated class representing the Announcement type in your schema. */
@immutable
class Announcement extends Model {
  static const classType = const _AnnouncementModelType();
  final String id;
  final String? _tripName;
  final String? _description;
  final TemporalDate? _startDate;
  final TemporalDate? _endDate;
  final bool? _isCompleted;
  final bool? _isPinned;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  AnnouncementModelIdentifier get modelIdentifier {
      return AnnouncementModelIdentifier(
        id: id
      );
  }
  
  String get tripName {
    try {
      return _tripName!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get description {
    try {
      return _description!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDate get startDate {
    try {
      return _startDate!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  TemporalDate get endDate {
    try {
      return _endDate!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get isCompleted {
    try {
      return _isCompleted!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get isPinned {
    try {
      return _isPinned!;
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
  
  const Announcement._internal({required this.id, required tripName, required description, required startDate, required endDate, required isCompleted, required isPinned, createdAt, updatedAt}): _tripName = tripName, _description = description, _startDate = startDate, _endDate = endDate, _isCompleted = isCompleted, _isPinned = isPinned, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Announcement({String? id, required String tripName, required String description, required TemporalDate startDate, required TemporalDate endDate, required bool isCompleted, required bool isPinned}) {
    return Announcement._internal(
      id: id == null ? UUID.getUUID() : id,
      tripName: tripName,
      description: description,
      startDate: startDate,
      endDate: endDate,
      isCompleted: isCompleted,
      isPinned: isPinned);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Announcement &&
      id == other.id &&
      _tripName == other._tripName &&
      _description == other._description &&
      _startDate == other._startDate &&
      _endDate == other._endDate &&
      _isCompleted == other._isCompleted &&
      _isPinned == other._isPinned;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Announcement {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("tripName=" + "$_tripName" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("startDate=" + (_startDate != null ? _startDate!.format() : "null") + ", ");
    buffer.write("endDate=" + (_endDate != null ? _endDate!.format() : "null") + ", ");
    buffer.write("isCompleted=" + (_isCompleted != null ? _isCompleted!.toString() : "null") + ", ");
    buffer.write("isPinned=" + (_isPinned != null ? _isPinned!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Announcement copyWith({String? tripName, String? description, TemporalDate? startDate, TemporalDate? endDate, bool? isCompleted, bool? isPinned}) {
    return Announcement._internal(
      id: id,
      tripName: tripName ?? this.tripName,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCompleted: isCompleted ?? this.isCompleted,
      isPinned: isPinned ?? this.isPinned);
  }
  
  Announcement.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _tripName = json['tripName'],
      _description = json['description'],
      _startDate = json['startDate'] != null ? TemporalDate.fromString(json['startDate']) : null,
      _endDate = json['endDate'] != null ? TemporalDate.fromString(json['endDate']) : null,
      _isCompleted = json['isCompleted'],
      _isPinned = json['isPinned'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'tripName': _tripName, 'description': _description, 'startDate': _startDate?.format(), 'endDate': _endDate?.format(), 'isCompleted': _isCompleted, 'isPinned': _isPinned, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id, 'tripName': _tripName, 'description': _description, 'startDate': _startDate, 'endDate': _endDate, 'isCompleted': _isCompleted, 'isPinned': _isPinned, 'createdAt': _createdAt, 'updatedAt': _updatedAt
  };

  static final QueryModelIdentifier<AnnouncementModelIdentifier> MODEL_IDENTIFIER = QueryModelIdentifier<AnnouncementModelIdentifier>();
  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField TRIPNAME = QueryField(fieldName: "tripName");
  static final QueryField DESCRIPTION = QueryField(fieldName: "description");
  static final QueryField STARTDATE = QueryField(fieldName: "startDate");
  static final QueryField ENDDATE = QueryField(fieldName: "endDate");
  static final QueryField ISCOMPLETED = QueryField(fieldName: "isCompleted");
  static final QueryField ISPINNED = QueryField(fieldName: "isPinned");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Announcement";
    modelSchemaDefinition.pluralName = "Announcements";
    
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
      key: Announcement.TRIPNAME,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Announcement.DESCRIPTION,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Announcement.STARTDATE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Announcement.ENDDATE,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Announcement.ISCOMPLETED,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Announcement.ISPINNED,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.bool)
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

class _AnnouncementModelType extends ModelType<Announcement> {
  const _AnnouncementModelType();
  
  @override
  Announcement fromJson(Map<String, dynamic> jsonData) {
    return Announcement.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Announcement';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Announcement] in your schema.
 */
@immutable
class AnnouncementModelIdentifier implements ModelIdentifier<Announcement> {
  final String id;

  /** Create an instance of AnnouncementModelIdentifier using [id] the primary key. */
  const AnnouncementModelIdentifier({
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
  String toString() => 'AnnouncementModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is AnnouncementModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}