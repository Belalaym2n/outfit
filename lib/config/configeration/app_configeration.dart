class AppConfiguration{

  static late String flavor;

  static bool get isDev => flavor == 'development';
  static bool get isProd => flavor == 'production';


  static String get userCollectionName =>
      !isDev ? 'Users' : 'users_development';

  static String get apartmentsCollectionName =>
      !isDev ? 'Apartments' : '_apartments_development';
  static String get blogsCollectionName =>
      isDev ? ' blogs_development' : 'Blogs';
  static String get lectures =>
      isDev ? 'lectures_development' : 'Lectures';

  static String get companiesCollectionName =>
      isDev ? 'companies_development' : 'Companies';
}

