import '../models/entities.dart';

class MockStore {
  final students = <Student>[
    const Student(id: 's1', name: 'محمد أحمد', phone: '01012345678', guardian: 'أحمد محمد', guardianPhone: '01112345678', birthDate: '2012/05/13', address: 'مدينة نصر', status: RecordStatus.active, group: 'الرياضيات المتقدمة'),
    const Student(id: 's2', name: 'سارة محمود', phone: '01098765432', guardian: 'محمود علي', guardianPhone: '01298765432', birthDate: '2011/09/02', address: 'المعادي', status: RecordStatus.active, group: 'اللغة الإنجليزية'),
    const Student(id: 's3', name: 'عمر خالد', phone: '01055556666', guardian: 'خالد عمر', guardianPhone: '01077778888', birthDate: '2013/01/20', address: 'مصر الجديدة', status: RecordStatus.inactive, group: 'البرمجة للصغار'),
    const Student(id: 's4', name: 'نور إيهاب', phone: '01122223333', guardian: 'إيهاب نور', guardianPhone: '01033334444', birthDate: '2010/12/09', address: 'الزمالك', status: RecordStatus.active, group: 'اللغة الإنجليزية'),
  ];
  final teachers = <Teacher>[
    const Teacher(id: 't1', name: 'د. أحمد سمير', email: 'ahmed@academy.test', phone: '01011112222', specialty: 'رياضيات', status: RecordStatus.active, groups: 3),
    const Teacher(id: 't2', name: 'أ. منى حسن', email: 'mona@academy.test', phone: '01099990000', specialty: 'لغة إنجليزية', status: RecordStatus.active, groups: 2),
    const Teacher(id: 't3', name: 'م. كريم عادل', email: 'karim@academy.test', phone: '01144445555', specialty: 'برمجة', status: RecordStatus.active, groups: 2),
  ];
  final groups = <Group>[
    const Group(id: 'g1', name: 'الرياضيات المتقدمة', subject: 'رياضيات', teacher: 'د. أحمد سمير', room: 'قاعة 1', schedule: 'الأحد والثلاثاء - 05:00 م', capacity: 20, fee: 650, students: 16),
    const Group(id: 'g2', name: 'اللغة الإنجليزية', subject: 'English', teacher: 'أ. منى حسن', room: 'قاعة 3', schedule: 'الاثنين والأربعاء - 04:00 م', capacity: 18, fee: 550, students: 14),
    const Group(id: 'g3', name: 'البرمجة للصغار', subject: 'برمجة', teacher: 'م. كريم عادل', room: 'معمل 1', schedule: 'السبت - 12:00 م', capacity: 15, fee: 700, students: 9),
  ];
  final lessons = <Lesson>[
    const Lesson(id: 'l1', title: 'المعادلات الخطية', group: 'الرياضيات المتقدمة', teacher: 'د. أحمد سمير', date: '27 سبتمبر 2026', time: '05:00 م', status: RecordStatus.present),
    const Lesson(id: 'l2', title: 'Conversation Skills', group: 'اللغة الإنجليزية', teacher: 'أ. منى حسن', date: '28 سبتمبر 2026', time: '04:00 م', status: RecordStatus.pending),
    const Lesson(id: 'l3', title: 'أساسيات Scratch', group: 'البرمجة للصغار', teacher: 'م. كريم عادل', date: '29 سبتمبر 2026', time: '12:00 م', status: RecordStatus.pending),
  ];
  final attendance = <AttendanceRecord>[
    const AttendanceRecord(id: 'a1', student: 'محمد أحمد', group: 'الرياضيات المتقدمة', date: '27 سبتمبر 2026', status: RecordStatus.present),
    const AttendanceRecord(id: 'a2', student: 'سارة محمود', group: 'اللغة الإنجليزية', date: '27 سبتمبر 2026', status: RecordStatus.present),
    const AttendanceRecord(id: 'a3', student: 'عمر خالد', group: 'البرمجة للصغار', date: '27 سبتمبر 2026', status: RecordStatus.absent),
    const AttendanceRecord(id: 'a4', student: 'نور إيهاب', group: 'اللغة الإنجليزية', date: '27 سبتمبر 2026', status: RecordStatus.present),
  ];
  final payments = <Payment>[
    const Payment(id: 'p1', studentId: 's1', student: 'محمد أحمد', month: 'سبتمبر 2026', requiredAmount: 650, paidAmount: 650, method: 'تحويل بنكي', date: '01/09/2026'),
    const Payment(id: 'p2', studentId: 's2', student: 'سارة محمود', month: 'سبتمبر 2026', requiredAmount: 550, paidAmount: 300, method: 'نقدي', date: '03/09/2026', notes: 'المتبقي نهاية الشهر'),
    const Payment(id: 'p3', studentId: 's4', student: 'نور إيهاب', month: 'سبتمبر 2026', requiredAmount: 550, paidAmount: 550, method: 'بطاقة', date: '02/09/2026'),
  ];
  String academyName = 'أكاديمية بلس';
  String academyLogo = 'شعار الأكاديمية';
  String academyPhone = '02 2456 7890';
  String academyEmail = 'hello@academyplus.test';
  String academyAddress = 'شارع النصر، القاهرة';
  String academyManager = 'أ. محمد إبراهيم';
  String academyDescription = 'أكاديمية تعليمية متخصصة في بناء مهارات الطلاب.';
}
