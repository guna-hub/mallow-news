import 'package:equatable/equatable.dart';

/// Parameter class for fetching a single article by its unique ID.
class GetArticleByIdParams extends Equatable {
  final int id;

  const GetArticleByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}
