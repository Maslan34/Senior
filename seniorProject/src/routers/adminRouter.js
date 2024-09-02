const router = require('express').Router();
const adminController = require('../controllers/adminController');

const authMiddleware = require('../middlewares/authMiddleware');

/*get*/   
router.get('/', authMiddleware.oturumAcilmis, adminController.showHomePage);
router.get('/announcements', authMiddleware.oturumAcilmis, adminController.Announcements);
router.get('/userRoles', authMiddleware.oturumAcilmis, adminController.UserRoles);
router.get('/addser', authMiddleware.oturumAcilmis, adminController.addser);
router.get('/addRoles', authMiddleware.oturumAcilmis, adminController.addRoles);
router.get('/contact', authMiddleware.oturumAcilmis, adminController.Contact);
router.get('/statistics', authMiddleware.oturumAcilmis, adminController.Statistics);
router.get('/viewProfile', authMiddleware.oturumAcilmis, adminController.ViewProfile);
router.get('/adminHomePage', authMiddleware.oturumAcilmis, adminController.AdminHomePage);





router.get('/sifredegistir',authMiddleware.oturumAcilmis,adminController.sifreDegistir)
router.get('/kullaniciEkle',authMiddleware.oturumAcilmis,adminController.KullaniciEkle)
router.get('/kullanicilariListele',authMiddleware.oturumAcilmis,adminController.kullanicilariListele)
router.get('/logout',authMiddleware.oturumAcilmis,adminController.logout)


router.post('/adminOnay',authMiddleware.oturumAcilmis,adminController.adminOnayMakale)
router.post('/sifreDegistir',authMiddleware.oturumAcilmis,adminController.sifreDegistirPost)
router.post('/addUser',authMiddleware.oturumAcilmis,adminController.AddUser)
router.post('/removeUser/:id',authMiddleware.oturumAcilmis,adminController.RemoveUser)
router.post('/editUser/:id',authMiddleware.oturumAcilmis,adminController.EditUser)


module.exports = router;