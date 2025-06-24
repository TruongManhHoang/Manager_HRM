class RouterName {
  static const schoolPage = '/school-page';
  static const splashScreen = '/splash-screen';
  static const dashboard = '/dashboard-page';
  static const commentManager = '/comment-manager-page';
  static const login = '/login';
  static const departmentPage = '/department-page';
  static const customSidebar = '/customSidebar';
  static const employeeDetailPage = '/employeeDetailPage';
  static const employeeDetailUserPage = "/employeeDetailUserPage";
  static const employeeDetailAccountingPage = "/employeeDetailAccountingPage";
  static const employeePage = '/employee-page';
  static const addEmployee = '/add-employee';
  static const addDepartment =
      'add-department'; // Nested route, không có dấu "/"
  static const contractPage = '/contract-page';
  static const addContract = 'add-contract'; // Nested route, không có dấu "/"
  static const addAccount = 'add-account'; // Nested route, không có dấu "/"
  static const editAccount = 'edit-account'; // Nested route, không có dấu "/"
  static const addPosition = 'add-position'; // Nested route, không có dấu "/"

  static const accountPage = '/account-page';
  static const positionPage = '/position-page';
  static const updateEmployee = '/update-employee';
  static const editDepartment =
      'edit-department'; // Nested route, không có dấu "/"

  static const rewardPage = '/reward-page';
  static const editReward = 'edit-reward'; // Nested route, không có dấu "/"
  static const addReward = 'add-reward'; // Nested route, không có dấu "/"
  static const disciplinaryPage = '/disciplinary-page';
  static const addDisciplinary =
      'add-disciplinary'; // Nested route, không có dấu "/"
  static const editDisciplinary =
      'edit-disciplinary'; // Nested route, không có dấu "/"
  static const editPosition = 'edit-position'; // Nested route, không có dấu "/"
  static const editContract = 'edit-contract'; // Nested route, không có dấu "/"

  static const attendancePage = '/attendance-page';
  static const addAttendance = 'add-attendance';
  static const editAttendance = 'edit-attendance';

  static const kpiPage = '/kpi-page';
  static const addKpi = 'add-kpi';
  static const editKpi = 'edit-kpi';
  static const salaryPage = '/salary-page';
  static const addSalary = 'add-salary'; // Nested route, không có dấu "/"
  static const editSalary = 'edit-salary'; // Nested route, không có dấu "/"
  static const employeeSalaryPage =
      'employee-salary'; // Nested route, không có dấu "/"

  static const reportPage = '/report-page';

  static const reportPageAccounting = '/report-page-accounting';
  static const sidebarMenuItem = [
    dashboard,
    departmentPage,
    employeePage,
    rewardPage,
    disciplinaryPage,
    contractPage,
    accountPage,
    positionPage,
    attendancePage,
    kpiPage,
    salaryPage,
    reportPage
  ];
  static const sidebarMenuItemsShort = [
    dashboard,
    departmentPage,
    employeePage,
    rewardPage,
    disciplinaryPage,
    accountPage,
    positionPage,
    attendancePage,
    kpiPage,
    salaryPage
  ];
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const logout = '/logout';

  static const sidebarMenuItemsFull = [
    schoolPage,
    dashboard,
    commentManager,
    departmentPage,
    salaryPage,
    logout,
  ];
}
