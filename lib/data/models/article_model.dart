import 'package:json_annotation/json_annotation.dart';

part 'article_model.g.dart';

@JsonSerializable()
class ArticleResponse {
  final int? count;
  final String? next;
  final dynamic previous;
  final List<ResultsResponse?>? results;

  ArticleResponse(this.count, this.next, this.previous, this.results);

  factory ArticleResponse.fromJson(Map<String, dynamic> json) => _$ArticleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleResponseToJson(this);
}

@JsonSerializable()
class ResultsResponse {
  final int? id;
  final String? title;
  final List<ResultsAuthorsResponse?>? authors;
  final String? url;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'news_site')
  final String? newsSite;
  final String? summary;
  @JsonKey(name: 'published_at')
  final String? publishedAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final bool? featured;
  final List<dynamic>? launches;
  final List<dynamic>? events;

  ResultsResponse(this.id, this.title, this.authors, this.url, this.imageUrl, this.newsSite, this.summary, this.publishedAt, this.updatedAt, this.featured, this.launches, this.events);

  factory ResultsResponse.fromJson(Map<String, dynamic> json) => _$ResultsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResultsResponseToJson(this);
}

@JsonSerializable()
class ResultsAuthorsResponse {
  final String? name;
  final dynamic socials;

  ResultsAuthorsResponse(this.name, this.socials);

  factory ResultsAuthorsResponse.fromJson(Map<String, dynamic> json) => _$ResultsAuthorsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResultsAuthorsResponseToJson(this);
}
