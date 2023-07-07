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

/** This is an auto generated class representing the CommentAnnouncement type in your schema. */
@immutable
class CommentAnnouncement extends Model {
  static const classType = const _CommentAnnouncementModelType();
  final String id;
  final String? _commentAuthor;
  final String? _commentContent;
  final Announcement? _announcement;
  final String? _content;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  CommentAnnouncementModelIdentifier get modelIdentifier {
    return CommentAnnouncementModelIdentifier(id: id);
  }

  String get commentAuthor {
    try {
      return _commentAuthor!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get commentContent {
    try {
      return _commentContent!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  Announcement? get announcement {
    return _announcement;
  }

  String get content {
    try {
      return _content!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  TemporalDateTime? get createdAt {
    return _createdAt;
  }

  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const CommentAnnouncement._internal(
      {required this.id,
      required commentAuthor,
      required commentContent,
      announcement,
      required content,
      createdAt,
      updatedAt})
      : _commentAuthor = commentAuthor,
        _commentContent = commentContent,
        _announcement = announcement,
        _content = content,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory CommentAnnouncement(
      {String? id,
      required String commentAuthor,
      required String commentContent,
      Announcement? announcement,
      required String content}) {
    return CommentAnnouncement._internal(
        id: id == null ? UUID.getUUID() : id,
        commentAuthor: commentAuthor,
        commentContent: commentContent,
        announcement: announcement,
        content: content,
        createdAt: TemporalDateTime.now());
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommentAnnouncement &&
        id == other.id &&
        _commentAuthor == other._commentAuthor &&
        _commentContent == other._commentContent &&
        _announcement == other._announcement &&
        _content == other._content;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("CommentAnnouncement {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("commentAuthor=" + "$_commentAuthor" + ", ");
    buffer.write("commentContent=" + "$_commentContent" + ", ");
    buffer.write("announcement=" +
        (_announcement != null ? _announcement!.toString() : "null") +
        ", ");
    buffer.write("content=" + "$_content" + ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  CommentAnnouncement copyWith(
      {String? commentAuthor,
      String? commentContent,
      Announcement? announcement,
      String? content}) {
    return CommentAnnouncement._internal(
        id: id,
        commentAuthor: commentAuthor ?? this.commentAuthor,
        commentContent: commentContent ?? this.commentContent,
        announcement: announcement ?? this.announcement,
        content: content ?? this.content,
        createdAt: TemporalDateTime.now());
  }

  CommentAnnouncement.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _commentAuthor = json['commentAuthor'],
        _commentContent = json['commentContent'],
        _announcement = json['announcement']?['serializedData'] != null
            ? Announcement.fromJson(new Map<String, dynamic>.from(
                json['announcement']['serializedData']))
            : null,
        _content = json['content'],
        _createdAt = json['createdAt'] != null
            ? TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'commentAuthor': _commentAuthor,
        'commentContent': _commentContent,
        'announcement': _announcement?.toJson(),
        'content': _content,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'commentAuthor': _commentAuthor,
        'commentContent': _commentContent,
        'announcement': _announcement,
        'content': _content,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final QueryModelIdentifier<CommentAnnouncementModelIdentifier>
      MODEL_IDENTIFIER =
      QueryModelIdentifier<CommentAnnouncementModelIdentifier>();
  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField COMMENTAUTHOR =
      QueryField(fieldName: "commentAuthor");
  static final QueryField COMMENTCONTENT =
      QueryField(fieldName: "commentContent");
  static final QueryField ANNOUNCEMENT = QueryField(
      fieldName: "announcement",
      fieldType: ModelFieldType(ModelFieldTypeEnum.model,
          ofModelName: 'Announcement'));
  static final QueryField CONTENT = QueryField(fieldName: "content");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "CommentAnnouncement";
    modelSchemaDefinition.pluralName = "CommentAnnouncements";

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
        key: CommentAnnouncement.COMMENTAUTHOR,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: CommentAnnouncement.COMMENTCONTENT,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.belongsTo(
        key: CommentAnnouncement.ANNOUNCEMENT,
        isRequired: false,
        targetNames: ['announcementCommentsId'],
        ofModelName: 'Announcement'));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: CommentAnnouncement.CONTENT,
        isRequired: true,
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

class _CommentAnnouncementModelType extends ModelType<CommentAnnouncement> {
  const _CommentAnnouncementModelType();

  @override
  CommentAnnouncement fromJson(Map<String, dynamic> jsonData) {
    return CommentAnnouncement.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'CommentAnnouncement';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [CommentAnnouncement] in your schema.
 */
@immutable
class CommentAnnouncementModelIdentifier
    implements ModelIdentifier<CommentAnnouncement> {
  final String id;

  /** Create an instance of CommentAnnouncementModelIdentifier using [id] the primary key. */
  const CommentAnnouncementModelIdentifier({required this.id});

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
  String toString() => 'CommentAnnouncementModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is CommentAnnouncementModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
