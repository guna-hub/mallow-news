import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mallow_news/data/models/article_model.dart';
import 'package:mallow_news/presentation/widgets/article_card.dart';

void main() {
  testWidgets('ArticleCard displays article title and news site', (WidgetTester tester) async {
    final article = ResultsResponse(
      101,
      'James Webb Telescope Discovers New Galaxy',
      [ResultsAuthorsResponse('Alex Smith', null)],
      'https://example.com/jwt',
      null,
      'SpaceNews',
      'Astronomers have discovered a distant galaxy using JWST.',
      '2026-11-17T08:30:00Z',
      '2026-11-17T08:30:00Z',
      false,
      [],
      [],
    );

    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArticleCard(
            article: article,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('James Webb Telescope Discovers New Galaxy'), findsOneWidget);
    expect(find.text('SpaceNews'), findsOneWidget);

    await tester.tap(find.byType(ArticleCard));
    expect(tapped, isTrue);
  });
}
