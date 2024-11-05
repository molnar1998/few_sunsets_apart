class PageControl{
  static int page = 0;

  static void updatePage(var newPage) {
    switch(newPage){
      case '/home':
        page = 0;
      case '/message':
        page = 1;
      case '/setting':
        page = 2;
      default:
        page = newPage;
    }
  }
}