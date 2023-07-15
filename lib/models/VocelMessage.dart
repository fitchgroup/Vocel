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

/** This is an auto generated class representing the VocelMessage type in your schema. */
@immutable
class VocelMessage extends Model {
  static const classType = const _VocelMessageModelType();
  final String id;
  final String? _content;
  final String? _messageImageUrl;
  final String? _messageImageKey;
  final String? _attachedLink;
  final String? _sender;
  final String? _receiver;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  VocelMessageModelIdentifier get modelIdentifier {
    return VocelMessageModelIdentifier(id: id);
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

  String? get messageImageUrl {
    return _messageImageUrl;
  }

  String? get messageImageKey {
    return _messageImageKey;
  }

  String? get attachedLink {
    return _attachedLink;
  }

  String get sender {
    try {
      return _sender!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get receiver {
    try {
      return _receiver!;
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

  const VocelMessage._internal(
      {required this.id,
      required content,
      messageImageUrl,
      messageImageKey,
      attachedLink,
      required sender,
      required receiver,
      createdAt,
      updatedAt})
      : _content = content,
        _messageImageUrl = messageImageUrl,
        _messageImageKey = messageImageKey,
        _attachedLink = attachedLink,
        _sender = sender,
        _receiver = receiver,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory VocelMessage(
      {String? id,
      required String content,
      String? messageImageUrl,
      String? messageImageKey,
      String? attachedLink,
      required String sender,
      required String receiver}) {
    return VocelMessage._internal(
        id: id == null ? UUID.getUUID() : id,
        content: content,
        messageImageUrl: messageImageUrl,
        messageImageKey: messageImageKey,
        attachedLink: attachedLink,
        sender: sender,
        receiver: receiver,
        createdAt: TemporalDateTime(TemporalDateTime.now().getDateTimeInUtc()));
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VocelMessage &&
        id == other.id &&
        _content == other._content &&
        _messageImageUrl == other._messageImageUrl &&
        _messageImageKey == other._messageImageKey &&
        _attachedLink == other._attachedLink &&
        _sender == other._sender &&
        _receiver == other._receiver;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("VocelMessage {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("content=" + "$_content" + ", ");
    buffer.write("messageImageUrl=" + "$_messageImageUrl" + ", ");
    buffer.write("messageImageKey=" + "$_messageImageKey" + ", ");
    buffer.write("attachedLink=" + "$_attachedLink" + ", ");
    buffer.write("sender=" + "$_sender" + ", ");
    buffer.write("receiver=" + "$_receiver" + ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  VocelMessage copyWith(
      {String? content,
      String? messageImageUrl,
      String? messageImageKey,
      String? attachedLink,
      String? sender,
      String? receiver}) {
    return VocelMessage._internal(
        id: id,
        content: content ?? this.content,
        messageImageUrl: messageImageUrl ?? this.messageImageUrl,
        messageImageKey: messageImageKey ?? this.messageImageKey,
        attachedLink: attachedLink ?? this.attachedLink,
        sender: sender ?? this.sender,
        receiver: receiver ?? this.receiver,
        createdAt: TemporalDateTime(TemporalDateTime.now().getDateTimeInUtc()));
  }

  VocelMessage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _content = json['content'],
        _messageImageUrl = json['messageImageUrl'],
        _messageImageKey = json['messageImageKey'],
        _attachedLink = json['attachedLink'],
        _sender = json['sender'],
        _receiver = json['receiver'],
        _createdAt = json['createdAt'] != null
            ? TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': _content,
        'messageImageUrl': _messageImageUrl,
        'messageImageKey': _messageImageKey,
        'attachedLink': _attachedLink,
        'sender': _sender,
        'receiver': _receiver,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'content': _content,
        'messageImageUrl': _messageImageUrl,
        'messageImageKey': _messageImageKey,
        'attachedLink': _attachedLink,
        'sender': _sender,
        'receiver': _receiver,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final QueryModelIdentifier<VocelMessageModelIdentifier>
      MODEL_IDENTIFIER = QueryModelIdentifier<VocelMessageModelIdentifier>();
  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField CONTENT = QueryField(fieldName: "content");
  static final QueryField MESSAGEIMAGEURL =
      QueryField(fieldName: "messageImageUrl");
  static final QueryField MESSAGEIMAGEKEY =
      QueryField(fieldName: "messageImageKey");
  static final QueryField ATTACHEDLINK = QueryField(fieldName: "attachedLink");
  static final QueryField SENDER = QueryField(fieldName: "sender");
  static final QueryField RECEIVER = QueryField(fieldName: "receiver");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "VocelMessage";
    modelSchemaDefinition.pluralName = "VocelMessages";

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
          authStrategy: AuthStrategy.GROUPS,
          groupClaim: "cognito:groups",
          groups: ["Bellversion1", "Eetcversion1", "Vcpaversion1"],
          provider: AuthRuleProvider.USERPOOLS,
          operations: [
            ModelOperation.CREATE,
            ModelOperation.DELETE,
            ModelOperation.READ,
            ModelOperation.UPDATE
          ]),
      AuthRule(
          authStrategy: AuthStrategy.PUBLIC, operations: [ModelOperation.READ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: VocelMessage.CONTENT,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: VocelMessage.MESSAGEIMAGEURL,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: VocelMessage.MESSAGEIMAGEKEY,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: VocelMessage.ATTACHEDLINK,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: VocelMessage.SENDER,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: VocelMessage.RECEIVER,
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

class _VocelMessageModelType extends ModelType<VocelMessage> {
  const _VocelMessageModelType();

  @override
  VocelMessage fromJson(Map<String, dynamic> jsonData) {
    return VocelMessage.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'VocelMessage';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [VocelMessage] in your schema.
 */
@immutable
class VocelMessageModelIdentifier implements ModelIdentifier<VocelMessage> {
  final String id;

  /** Create an instance of VocelMessageModelIdentifier using [id] the primary key. */
  const VocelMessageModelIdentifier({required this.id});

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
  String toString() => 'VocelMessageModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is VocelMessageModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
