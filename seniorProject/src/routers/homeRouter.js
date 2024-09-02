const router = require('express').Router();
const homeController = require('../controllers/homeController');
const multerConfig = require('../config/multerConfig');
const UserController = require('../controllers/UserController');

router.get('/homePage',UserController.IsDecoded,UserController.homePage);
router.get('/login',UserController.IsDecoded,UserController.loginGet);
router.get('/archives',UserController.IsDecoded,UserController.ArchivesGet)
router.get('/announcement',UserController.IsDecoded,UserController.AnnouncementsGet)
router.get('/contact',UserController.IsDecoded,UserController.ContactGet)
router.get('/aboutTheJournal',UserController.IsDecoded,UserController.AboutTheJournalGet)
router.get('/Submission',UserController.IsDecoded,UserController.SubmissionGet)
router.get('/editorialTeam',UserController.IsDecoded,UserController.editorialTeamGet)
router.get('/privacyStatement',UserController.IsDecoded,UserController.privacyStatementGet)
router.get('/register',UserController.IsDecoded,UserController.RegisterGet)


router.get('/user/panel',UserController.IsDecoded,UserController.IsLogged,UserController.checkUserRole([1,2,3]),UserController.userPanelMainPageGet)
router.get('/user/makaleler',UserController.IsDecoded,UserController.IsLogged,UserController.checkUserRole([1,2,3]),UserController.UserMakaleGet)
router.get('/user/makaleInceleme',UserController.IsDecoded,UserController.IsLogged,UserController.checkUserRole([2,3]),UserController.UserMakaleInceleGet)
router.get('/user/makaleEditor',UserController.IsDecoded,UserController.IsLogged,UserController.checkUserRole([2,3]),UserController.UserMakaleEditorGet)
router.get('/user/hakemeGonder',UserController.IsDecoded,UserController.IsLogged,UserController.checkUserRole([2,3]),UserController.hakemeGonder)
router.get('/user/user-add-thesis',UserController.IsDecoded,UserController.IsLogged,UserController.checkUserRole([1,2,3]),UserController.userPanelAddThesisPageGet)
router.get('/user/makaleGuncelle/:makaleID', UserController.IsDecoded, UserController.IsLogged, UserController.checkUserRole([1, 2, 3]), UserController.makaleRevisionPageGet);


router.get('/logout',UserController.logout)
router.post('/test',homeController.test)

router.post('/hakemeGonderPost',UserController.hakemeGonderPost)
router.post('/registerPost', UserController.Register);
router.post('/loginPost', UserController.IsDecoded,UserController.LoginPost);
router.post('/makaleEkle', UserController.IsDecoded,UserController.IsLogged,UserController.checkUserRole([1,2,3]),multerConfig.single('pdf_thesis'),UserController.makaleEkle);
router.post('/makaleRevisionPost/:makaleID', UserController.IsDecoded,UserController.IsLogged,UserController.checkUserRole([1,2,3]),multerConfig.single('pdf_thesis'),UserController.makaleRevisionPost);
router.post('/refreeNotesPost', UserController.IsDecoded,UserController.IsLogged,UserController.checkUserRole([2,3]),multerConfig.single('refreePdf'),UserController.refreeNotesPost);
router.post('/editorDecisionPost', UserController.IsDecoded,UserController.IsLogged,UserController.checkUserRole([3]),UserController.editorDecisionPost);




//Login
router.post('/api/getProduct',homeController.AuthorizationCheck,homeController.getProduct)
router.post('/api/getSayimList',homeController.AuthorizationCheck,homeController.getSayimList)
router.post('/api/postSayim',homeController.AuthorizationCheck,homeController.postSayim)
router.post('/api/login',homeController.AuthorizationCheck,homeController.LoginPost)








module.exports = router;
