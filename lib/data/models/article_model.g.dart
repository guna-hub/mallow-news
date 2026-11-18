// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleResponse _$ArticleResponseFromJson(Map<String, dynamic> json) =>
    ArticleResponse(
      (json['count'] as num?)?.toInt(),
      json['next'] as String?,
      json['previous'],
      (json['results'] as List<dynamic>?)
          ?.map(
            (e) => e == null
                ? null
                : ResultsResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$ArticleResponseToJson(ArticleResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };

ResultsResponse _$ResultsResponseFromJson(Map<String, dynamic> json) =>
    ResultsResponse(
      (json['id'] as num?)?.toInt(),
      json['title'] as String?,
      (json['authors'] as List<dynamic>?)
          ?.map(
            (e) => e == null
                ? null
                : ResultsAuthorsResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      json['url'] as String?,
      json['image_url'] as String?,
      json['news_site'] as String?,
      json['summary'] as String?,
      json['published_at'] as String?,
      json['updated_at'] as String?,
      json['featured'] as bool?,
      json['launches'] as List<dynamic>?,
      json['events'] as List<dynamic>?,
    );

Map<String, dynamic> _$ResultsResponseToJson(ResultsResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authors': instance.authors,
      'url': instance.url,
      'image_url': instance.imageUrl,
      'news_site': instance.newsSite,
      'summary': instance.summary,
      'published_at': instance.publishedAt,
      'updated_at': instance.updatedAt,
      'featured': instance.featured,
      'launches': instance.launches,
      'events': instance.events,
    };

ResultsAuthorsResponse _$ResultsAuthorsResponseFromJson(
  Map<String, dynamic> json,
) => ResultsAuthorsResponse(json['name'] as String?, json['socials']);

Map<String, dynamic> _$ResultsAuthorsResponseToJson(
  ResultsAuthorsResponse instance,
) => <String, dynamic>{'name': instance.name, 'socials': instance.socials};
