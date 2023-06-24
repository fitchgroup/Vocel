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
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the Post type in your schema. */
@immutable
class Post extends Model {
  static const classType = const _PostModelType();
  final String id;
  final String? _postAuthor;
  final String? _postContent;
  final List<String>? _likes;
  final List<Comment>? _comments;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  PostModelIdentifier get modelIdentifier {
    return PostModelIdentifier(id: id);
  }

  String get postAuthor {
    try {
      return _postAuthor!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get postContent {
    try {
      return _postContent!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  List<String>? get likes {
    return _likes;
  }

  List<Comment>? get comments {
    return _comments;
  }

  TemporalDateTime? get createdAt {
    return _createdAt;
  }

  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const Post._internal(
      {required this.id,
      required postAuthor,
      required postContent,
      likes,
      comments,
      createdAt,
      updatedAt})
      : _postAuthor = postAuthor,
        _postContent = postContent,
        _likes = likes,
        _comments = comments,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory Post(
      {String? id,
      required String postAuthor,
      required String postContent,
      List<String>? likes,
      List<Comment>? comments}) {
    return Post._internal(
        id: id == null ? UUID.getUUID() : id,
        postAuthor: postAuthor,
        postContent: postContent,
        likes: likes != null ? List<String>.unmodifiable(likes) : likes,
        comments:
            comments != null ? List<Comment>.unmodifiable(comments) : comments,
        createdAt: TemporalDateTime.now());
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Post &&
        id == other.id &&
        _postAuthor == other._postAuthor &&
        _postContent == other._postContent &&
        DeepCollectionEquality().equals(_likes, other._likes) &&
        DeepCollectionEquality().equals(_comments, other._comments);
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Post {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("postAuthor=" + "$_postAuthor" + ", ");
    buffer.write("postContent=" + "$_postContent" + ", ");
    buffer.write(
        "likes=" + (_likes != null ? _likes!.toString() : "null") + ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Post copyWith(
      {String? postAuthor,
      String? postContent,
      List<String>? likes,
      List<Comment>? comments}) {
    return Post._internal(
        id: id,
        postAuthor: postAuthor ?? this.postAuthor,
        postContent: postContent ?? this.postContent,
        likes: likes ?? this.likes,
        comments: comments ?? this.comments);
  }

  Post.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _postAuthor = json['postAuthor'],
        _postContent = json['postContent'],
        _likes = json['likes']?.cast<String>(),
        _comments = json['comments'] is List
            ? (json['comments'] as List)
                .where((e) => e?['serializedData'] != null)
                .map((e) => Comment.fromJson(
                    new Map<String, dynamic>.from(e['serializedData'])))
                .toList()
            : null,
        _createdAt = json['createdAt'] != null
            ? TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'postAuthor': _postAuthor,
        'postContent': _postContent,
        'likes': _likes,
        'comments': _comments?.map((Comment? e) => e?.toJson()).toList(),
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'postAuthor': _postAuthor,
        'postContent': _postContent,
        'likes': _likes,
        'comments': _comments,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final QueryModelIdentifier<PostModelIdentifier> MODEL_IDENTIFIER =
      QueryModelIdentifier<PostModelIdentifier>();
  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField POSTAUTHOR = QueryField(fieldName: "postAuthor");
  static final QueryField POSTCONTENT = QueryField(fieldName: "postContent");
  static final QueryField LIKES = QueryField(fieldName: "likes");
  static final QueryField COMMENTS = QueryField(
      fieldName: "comments",
      fieldType:
          ModelFieldType(ModelFieldTypeEnum.model, ofModelName: 'Comment'));
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Post";
    modelSchemaDefinition.pluralName = "Posts";

    modelSchemaDefinition.authRules = [
      AuthRule(
          authStrategy: AuthStrategy.OWNER,
          ownerField: "owner",
          identityClaim: "cognito:username",
          provider: AuthRuleProvider.USERPOOLS,
          operations: [
            ModelOperation.READ,
            ModelOperation.UPDATE,
            ModelOperation.DELETE
          ]),
      AuthRule(
          authStrategy: AuthStrategy.PUBLIC, operations: [ModelOperation.READ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Post.POSTAUTHOR,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Post.POSTCONTENT,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Post.LIKES,
        isRequired: false,
        isArray: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.collection,
            ofModelName: describeEnum(ModelFieldTypeEnum.string))));

    modelSchemaDefinition.addField(ModelFieldDefinition.hasMany(
        key: Post.COMMENTS,
        isRequired: false,
        ofModelName: 'Comment',
        associatedKey: Comment.POST));

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

class _PostModelType extends ModelType<Post> {
  const _PostModelType();

  @override
  Post fromJson(Map<String, dynamic> jsonData) {
    return Post.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'Post';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Post] in your schema.
 */
@immutable
class PostModelIdentifier implements ModelIdentifier<Post> {
  final String id;

  /** Create an instance of PostModelIdentifier using [id] the primary key. */
  const PostModelIdentifier({required this.id});

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
  String toString() => 'PostModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is PostModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
