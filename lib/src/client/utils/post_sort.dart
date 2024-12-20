/// Given a standard string sort, returns the proper Lemmy API sort string.
///
/// TODO: Add back v3/v4 compatible time-based sorting (e.g., hour, day, week, month, year, all)
String getSort(String sort, String version) {
  return switch (sort) {
    'active' => 'Active',
    'hot' => 'Hot',
    'new' => 'New',
    'old' => 'Old',
    'top' => 'Top',
    'most_comments' => 'MostComments',
    'new_comments' => 'NewComments',
    'controversial' => 'Controversial',
    'scaled' => 'Scaled',
    _ => throw Exception('Invalid sort type'),
  };
}
