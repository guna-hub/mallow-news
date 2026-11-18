import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class FetchInitialNews extends NewsEvent {
  const FetchInitialNews();
}

class RefreshNews extends NewsEvent {
  const RefreshNews();
}

class LoadMoreNews extends NewsEvent {
  const LoadMoreNews();
}

class SearchQueryChanged extends NewsEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class CategorySelected extends NewsEvent {
  final String category;

  const CategorySelected(this.category);

  @override
  List<Object?> get props => [category];
}
