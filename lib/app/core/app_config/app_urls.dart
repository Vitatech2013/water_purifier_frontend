class AppURL {
  AppURL._();

  //Urls
  // static const appBaseUrl = 'http://78.142.47.247:7000';
  static const appBaseUrl = 'http://78.142.47.247:7002';
  //login
  // static const login = '/api/owner/login';
  static const login = '/api/auth/login';
  //products
  static const addProduct = '/api/product/add';
  static const fetchProducts = '/api/product/';
  static const updateProducts = '/api/product/';
  static const deleteProduct = '/api/product/';
  //services
  static const addService = '/api/service/add';
  static const fetchService = '/api/service/';
  static const updateService = '/api/service/';
  static const deleteService = '/api/service/';
  //sales
  static const addSale = '/api/sale/add';
  static const fetchSale = '/api/sale';
  //addServiceInsideSale
  static const addServiceInsideSale = '/api/sale/addservice';

  //edit person
    static const editPerson ='/api/user/users/';

    //technician
    static const addTechnician='/api/technician/register';
    static const getTechnician='/api/technician/';
    static const editTechnician='/api/technician/';
    static const deleteTechnician='/api/technician/';
}
